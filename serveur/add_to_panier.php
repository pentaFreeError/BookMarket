<?php
session_start();
require_once 'Database.php';
if (!isset($_SESSION['user_id'])) {
    header("Location: login.html?error=loginFirst");
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $code = $_POST['code'] ?? '';

    if (!empty($code)) {
        $db = new Database();
        $pdo = $db->connect();
        $result = $db->ajouterAuPanier($_SESSION['user_id'], $code);

        if ($result) {
            echo json_encode(["status" => "success"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Échec d'ajout au panier"]);
        }

        $db->disconnect();
    } else {
        echo json_encode(["status" => "error", "message" => "Données invalides"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Méthode non autorisée"]);
}
?>