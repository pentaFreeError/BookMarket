<?php
session_start();
require_once 'Database.php';

if (!isset($_SESSION['user_id'])) {
    echo json_encode(["status" => "error", "message" => "Utilisateur non connecté"]);
    exit();
}

$client_id = $_SESSION['user_id'];
$db = new Database();
$pdo = $db->connect();

if (!$pdo) {
    echo json_encode(["status" => "error", "message" => "Erreur de connexion à la base de données"]);
    exit();
}

try {
    $sql = "DELETE FROM panier WHERE client_id = :client_id";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['client_id' => $client_id]);

    echo json_encode(["status" => "success"]);
} catch (PDOException $e) {
    error_log("Erreur lors de la suppression du panier: " . $e->getMessage());
    echo json_encode(["status" => "error", "message" => "Erreur lors de la suppression du panier"]);
}

$db->disconnect();
?>