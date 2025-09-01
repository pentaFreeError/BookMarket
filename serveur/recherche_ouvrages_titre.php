<?php

header("Content-Type: application/json; charset=UTF-8");

$debtitre = null;

if (isset($_GET["debtitre"])){
    $debtitre = $_GET["debtitre"];
} else {
    die ("Debtitre inconnu");
}

require_once 'Database.php';

$db = new Database();

$pdo = $db->connect();

if ($pdo && $debtitre) {
    $authors = $db->getOuvrageByPrefix($debtitre); 
    echo $authors;
    $db->disconnect();
} else {
    die ("PDO connection impossible");
}
?>