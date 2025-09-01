\connect livres

DROP TABLE IF EXISTS Commande;
DROP TABLE IF EXISTS Panier;
DROP TABLE IF EXISTS Clients;

CREATE TABLE Clients (
    client_id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    code_postal VARCHAR(10) NOT NULL,
    ville VARCHAR(50) NOT NULL,
    pays VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    date_inscription DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE Panier (
    client_id INT NOT NULL,
    code_exemplaire INT NOT NULL,
    quantite INT NOT NULL CHECK (quantite > 0),
    PRIMARY KEY (client_id, code_exemplaire),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE
);

CREATE TABLE Commande (
    client_id INT NOT NULL,
    code_exemplaire INT NOT NULL,
    quantite INT NOT NULL CHECK (quantite > 0),
    prix DECIMAL(10,2) NOT NULL CHECK (prix >= 0),
    date_commande DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (client_id, code_exemplaire, date_commande),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE
);