<?php
require_once 'Database.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nom = trim($_POST['nom'] ?? '');
    $prenom = trim($_POST['prenom'] ?? '');
    $adresse = trim($_POST['adresse'] ?? '');
    $ville = trim($_POST['ville'] ?? '');
    $pays = trim($_POST['pays'] ?? '');
    $code_postal = trim($_POST['code_postal'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $password = trim($_POST['password'] ?? '');

    if (empty($nom) || empty($prenom) || empty($adresse) || empty($ville) || empty($pays) || empty($code_postal) || empty($email) || empty($password)) {
        header("Location: login.html?error=inconnu");
        $db->disconnect();
        exit();
    }

    $db = new Database();
    $pdo = $db->connect();
    if (!$pdo) {
        header("Location: login.html?error=database");
        $db->disconnect();
        exit();
    }

    if ($db->emailUsed($email)) {
        header("Location: login.html?error=mailExist");
        $db->disconnect();
        exit();
    }

    $userId = $db->saveUser($nom, $prenom, $adresse, $code_postal, $ville, $pays, $email, $password);
    
    if ($userId) {
        header("Location: login.html?error=saved");
        $db->disconnect();
        exit();
    } else {
        header("Location: login.html?error=inconnu");
        $db->disconnect();
        exit();
    }
} 