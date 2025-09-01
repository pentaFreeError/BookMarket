<?php

class Database {
    private $host = "localhost"; 
    private $dbname = "livres"; 
    private $user = "lbrun"; 
    private $password = "root"; 
    private $pdo; 

    public function connect() {
        try {
            $dsn = "pgsql:host={$this->host};dbname={$this->dbname}";
            $this->pdo = new PDO($dsn, $this->user, $this->password, [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
            ]);
            return $this->pdo; 
        } catch (PDOException $e) {
            error_log("PostgreSQL Connection Error: " . $e->getMessage());
            return false; 
        }
    }

    public function disconnect() {
        $this->pdo = null; 
    }

    public function getAuthorsByPrefix($prefix) {
        if (!$this->pdo) {
            return false; 
        }

        try {
            $sql = "SELECT code, nom, prenom FROM auteurs 
                    WHERE LOWER(nom) LIKE LOWER(:prefix) || '%'";
            
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute(['prefix' => $prefix]); 
            return json_encode($stmt->fetchAll(PDO::FETCH_ASSOC), JSON_PRETTY_PRINT); 
        } catch (PDOException $e) {
            error_log("Query Error: " . $e->getMessage());
            return false;
        }
    }

    public function getOuvrageByPrefix($prefix) {
        
        if (!$this->pdo) {
            return false;
        }

        try {
            $sql = "SELECT o.code, 
                        o.nom, 
                        json_agg(
                            json_build_object(
                                'nom', e.nom,
                                'code', ex.code,
                                'prix', ex.prix
                            )
                        )::json AS exemplaires  
                FROM ouvrage o
                JOIN exemplaire ex ON o.code = ex.code_ouvrage
                JOIN editeurs e ON e.code = ex.code_editeur
                WHERE o.nom ILIKE :prefix || '%'
                GROUP BY o.code, o.nom
                ORDER BY o.nom ASC";

            $stmt = $this->pdo->prepare($sql);
            $stmt->execute(['prefix' => $prefix]);
            $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

            foreach ($result as &$row) {
                $row['exemplaires'] = json_decode($row['exemplaires'], true);
            }

            return json_encode($result, JSON_PRETTY_PRINT);  
        } catch (PDOException $e) {
            error_log("Query Error: " . $e->getMessage());
            return false;
        }
    }

    public function getOuvrageByAuthorCode($code) {
        
        if (!$this->pdo) {
            return false;
        }

        try {
            $sql = "SELECT o.code, 
                       o.nom, 
                       json_agg(
                            json_build_object(
                                'nom', e.nom,
                                'code', ex.code,
                                'prix', ex.prix
                            )
                       )::json AS exemplaires  
                FROM ouvrage o
                JOIN ecrit_par ep ON o.code = ep.code_ouvrage
                JOIN auteurs a ON a.code = ep.code_auteur
                JOIN exemplaire ex ON o.code = ex.code_ouvrage
                JOIN editeurs e ON e.code = ex.code_editeur
                WHERE a.code = :code
                GROUP BY o.code, o.nom
                ORDER BY o.nom ASC";

            $stmt = $this->pdo->prepare($sql);
            $stmt->execute(['code' => $code]);
            $books = $stmt->fetchAll(PDO::FETCH_ASSOC);

            foreach ($books as &$book) {
                $book['exemplaires'] = json_decode($book['exemplaires'], true);
            }

            return json_encode($books, JSON_PRETTY_PRINT);
        } catch (PDOException $e) {
            error_log("Query Error: " . $e->getMessage());
            return false;
        }
    }

    public function saveUser($nom, $prenom, $adresse, $code_postal, $ville, $pays, $email, $mot_de_passe) {
        if (!$this->pdo) {
            return false;
        }

        try {
            $sql = "INSERT INTO Clients (nom, prenom, adresse, code_postal, ville, pays, email, mot_de_passe, date_inscription) 
                    VALUES (:nom, :prenom, :adresse, :code_postal, :ville, :pays, :email, :mot_de_passe, CURRENT_DATE) 
                    RETURNING client_id";
            
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute([
                'nom' => $nom,
                'prenom' => $prenom,
                'adresse' => $adresse,
                'code_postal' => $code_postal,
                'ville' => $ville,
                'pays' => $pays,
                'email' => $email,
                'mot_de_passe' => password_hash($mot_de_passe, PASSWORD_DEFAULT) 
            ]);
            
            return $stmt->fetchColumn(); 
        } catch (PDOException $e) {
            error_log("Insertion Error: " . $e->getMessage());
            return false;
        }
    }

    public function emailUsed($email) {
        if (!$this->pdo) {
            return false;
        }

        try {

            $sql = "SELECT COUNT(*) FROM Clients WHERE email = :email";
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute(['email' => $email]);
            $count = $stmt->fetchColumn();

            return $count > 0; 
        
        } catch (PDOException $e) {
            error_log("Query Error: " . $e->getMessage());
            return false;
        }
}

    public function getUserByEmailAndPassword($email, $password) {
        if (!$this->pdo) {
            return false;
        }

        try {
            $sql = "SELECT * FROM Clients WHERE email = :email";
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute(['email' => $email]);
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($user && password_verify($password, $user['mot_de_passe'])) {
                unset($user['mot_de_passe']); 
                return $user;
            }
            return false;
        } catch (PDOException $e) {
            error_log("Query Error: " . $e->getMessage());
            return false;
        }
    }
    
    public function ajouterAuPanier($client_id, $code_exemplaire) {
        if (!$this->pdo) {
            return false;
        }

        try {
            $sql = "SELECT quantite FROM Panier WHERE client_id = :client_id AND code_exemplaire = :code_exemplaire";
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute([
                'client_id' => $client_id,
                'code_exemplaire' => $code_exemplaire
            ]);
            $row = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($row) {
                // L'article existe déjà, augmenter la quantité
                $sql = "UPDATE Panier SET quantite = quantite + 1 WHERE client_id = :client_id AND code_exemplaire = :code_exemplaire";
            } else {
                // L'article n'existe pas, l'ajouter avec quantité = 1
                $sql = "INSERT INTO Panier (client_id, code_exemplaire, quantite) VALUES (:client_id, :code_exemplaire, 1)";
            }

            $stmt = $this->pdo->prepare($sql);
            $stmt->execute([
                'client_id' => $client_id,
                'code_exemplaire' => $code_exemplaire
            ]);

            return true;
        } catch (PDOException $e) {
            error_log("Erreur panier : " . $e->getMessage());
            return false;
        }
    }

    public function getPanierDetails($client_id, $code_exemplaire) {
        if (!$this->pdo) {
            return false;
        }
    
        try {
            $sql = "SELECT 
                        o.nom AS ouvrage_nom,
                        e.nom AS editeur_nom,
                        ex.prix AS prix_unitaire,
                        p.quantite
                    FROM panier p
                    JOIN exemplaire ex ON p.code_exemplaire = ex.code
                    JOIN ouvrage o ON ex.code_ouvrage = o.code
                    JOIN editeurs e ON ex.code_editeur = e.code
                    WHERE p.client_id = :client_id AND p.code_exemplaire = :code_exemplaire
                    ORDER BY o.nom";
    
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute([
                'client_id' => $client_id,
                'code_exemplaire' => $code_exemplaire
            ]);
    
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Erreur getPanierDetails: " . $e->getMessage());
            return false;
        }
    }
}
?>
