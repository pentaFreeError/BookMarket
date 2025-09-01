<?php
session_start();
require_once 'Database.php';

if (!isset($_SESSION['user_id'])) {
    header("Location: login.html?error=loginFirst");
    exit();
}

$db = new Database();
$pdo = $db->connect();

if (!$pdo) {
    die("Erreur de connexion à la base de données.");
}

$client_id = $_SESSION['user_id'];

$sql = "SELECT p.code_exemplaire FROM panier p WHERE p.client_id = :client_id";
$stmt = $pdo->prepare($sql);
$stmt->execute(['client_id' => $client_id]);
$exemplaires = $stmt->fetchAll(PDO::FETCH_COLUMN);

$articles = [];
foreach ($exemplaires as $code_exemplaire) {
    $article = $db->getPanierDetails($client_id, $code_exemplaire);
    if ($article) {
        $articles[] = $article;
    }
}

function handle_new_connection_counter() {
    $is_visited_cookie = "c29udV8yMDIyLGxvbF84LjAsZGVmYXVsdCwyMDIyLTA5LTA3LTIwOjAyOjMx";
    $counter = (int) trim(file_get_contents("../ressources/counter.txt")); 

    if(!isset($_COOKIE[$is_visited_cookie])) {
        $counter++;
        setcookie($is_visited_cookie, "1", time() + (60 * 60), "/");
    }   
    
    file_put_contents("../ressources/counter.txt", $counter);
    return $counter;
}

$counter = handle_new_connection_counter();

$db->disconnect();
$nom =$_SESSION['nom'];
$prenom =$_SESSION['prenom'];

include '../secure_html/panier.html';