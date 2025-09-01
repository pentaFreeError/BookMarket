<?php
    session_start();
    require_once 'Database.php';

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

    session_start();
    if (!isset($_SESSION['user_id'])) {
        header("Location: login.html");
        exit();
    } else {
        $nom = $_SESSION['nom'];
        $prenom = $_SESSION['prenom'];
        include '../secure_html/accueil.html';
    }
?>

