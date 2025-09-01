<?php

header("Content-Type: application/json; charset=UTF-8");

$debnom = null;

if (isset($_GET["debnom"])){
    $debnom=$_GET["debnom"];
} else {
    die ("Debnom inconnu");
}

require_once 'Database.php';

$db = new Database();

$pdo = $db->connect();

if ($pdo && $debnom) {
    $authors = $db->getAuthorsByPrefix($debnom); 
    echo $authors;
    $db->disconnect();
} else {
    die ("PDO connection impossible");
}
?>