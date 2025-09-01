<?php

header("Content-Type: application/json; charset=UTF-8");

$code = null;

if (isset($_GET["code"])){
    $code = $_GET["code"];
} else {
    die ("code inconnu");
}

require_once 'Database.php';

$db = new Database();

$pdo = $db->connect();

if ($pdo && $code) {
    $authors = $db->getOuvrageByAuthorCode($code); 
    echo $authors;
    $db->disconnect();
} else {
    die ("PDO connection impossible");
}
?>