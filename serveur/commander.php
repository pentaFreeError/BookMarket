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
    $pdo->beginTransaction();

    $sql_check = "SELECT p.client_id, p.code_exemplaire, p.quantite, ex.prix 
                  FROM panier p 
                  JOIN exemplaire ex ON p.code_exemplaire = ex.code
                  WHERE p.client_id = :client_id";
    $stmt_check = $pdo->prepare($sql_check);
    $stmt_check->execute(['client_id' => $client_id]);
    $panier_items = $stmt_check->fetchAll(PDO::FETCH_ASSOC);

    if (empty($panier_items)) {
        echo json_encode(["status" => "error", "message" => "Panier vide ou problème de données"]);
        exit();
    }

    $sql_insert = "INSERT INTO commande (client_id, code_exemplaire, quantite, prix, date_commande)
                   VALUES (:client_id, :code_exemplaire, :quantite, :prix, CURRENT_DATE)";
    $stmt_insert = $pdo->prepare($sql_insert);

    foreach ($panier_items as $item) {
        if ($item['prix'] === null) {
            error_log("Prix null détecté pour l'exemplaire " . $item['code_exemplaire']);
            continue;
        }
        $stmt_insert->execute([
            'client_id' => $item['client_id'],
            'code_exemplaire' => $item['code_exemplaire'],
            'quantite' => $item['quantite'],
            'prix' => $item['prix']
        ]);
    }

    $sql_delete = "DELETE FROM panier WHERE client_id = :client_id";
    $stmt_delete = $pdo->prepare($sql_delete);
    $stmt_delete->execute(['client_id' => $client_id]);

    $pdo->commit();
    echo json_encode(["status" => "success"]);
} catch (PDOException $e) {
    $pdo->rollBack();
    error_log("Erreur lors du transfert du panier vers la commande: " . $e->getMessage());
    echo json_encode(["status" => "error", "message" => "Erreur lors de la commande"]);
}

$db->disconnect();
?>
