<?php
session_start();
require_once 'Database.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $password = trim($_POST['password'] ?? '');

    if (empty($email) || empty($password)) {
        header("Location: login.html?error=inconnu");
        exit();
    }

    $db = new Database();
    $pdo = $db->connect();
    if (!$pdo) {
        header("Location: login.html?error=database");
        exit();
    }

    if (!$db->emailUsed($email)) {
        header("Location: login.html?error=mailExist");
        $db->disconnect();
        exit();
    }

    $user = $db->getUserByEmailAndPassword($email, $password);
    
    if ($user) {
        $_SESSION['user_id'] = $user['client_id'];
        $_SESSION['nom'] = $user['nom'];
        $_SESSION['prenom'] = $user['prenom'];
        
        $db->disconnect();
        header("Location: index.php"); 
        exit();
    } else {
        header("Location: login.html?error=notFound");
        $db->disconnect();
        exit();
    }
}