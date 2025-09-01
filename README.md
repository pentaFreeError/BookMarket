# Projet de Gestion de Livres

## Démonstration
Une vidéo démonstration de la version finale du projet est disponible sur YouTube :
[Voir la vidéo](https://www.youtube.com/watch?v=nZAR38olOUw)

## Lancement du Serveur (en Localhost)
### 1. Démarrer le serveur PHP
Se placer dans le dossier du serveur et exécuter la commande suivante :
```bash
php -S 0.0.0.0:3000
```

### 2. Démarrer le serveur PostgreSQL (si ce n'est pas déjà fait)
```bash
sudo systemctl restart postgresql
```

### 3. Initialisation de la base de données
Copier les fichiers SQL dans le répertoire `/tmp` :
```bash
cp ressources/livre.sql /tmp
cp ressources/tp03.sql /tmp
```

Ouvrir l'interpréteur `psql` :
```bash
sudo -iu postgres psql
```

Créer un utilisateur PostgreSQL nommé `lbrun` si ce n'est pas déjà fait :
```sql
CREATE USER lbrun WITH PASSWORD 'root';
```

Exécuter les fichiers SQL dans cet ordre :
```sql
\i /tmp/livre.sql
\i /tmp/tp03.sql
```

### 4. Configuration de la base de données
Dans le fichier `Database.php`, modifier les paramètres pour les adapter à votre configuration PostgreSQL :
```php
private $host = "localhost"; 
private $dbname = "livres"; 
private $user = "lbrun"; 
private $password = "root"; 
private $pdo; 
```
Assurez-vous que l'utilisateur PostgreSQL a les droits d'accès nécessaires aux tables.

### 5. Accéder à l'application
Ouvrir un navigateur et aller sur :
[http://127.0.0.1:3000/](http://127.0.0.1:3000/)

---

## Sécurité
L'application est sécurisée contre les attaques XSS et SQL injection en préparant toutes les requêtes utilisant les entrées utilisateur.

- Les mots de passe sont hachés et doivent respecter des critères de robustesse.
- L'accès aux pages sensibles est restreint aux utilisateurs connectés.
- Les cookies sont hachés pour éviter leur exploitation malveillante.
- Conformité au RGPD : aucune donnée personnelle n'est utilisée. Les ID clients sont générés aléatoirement et ne sont pas liés aux utilisateurs.

---

## Modularité
La gestion de la base de données est encapsulée dans la classe `Database.php`, permettant ainsi une séparation claire entre la logique métier et l'accès aux données.

---

## Auteur
**Kalash Abdulaziz**  
Email : [abdulaziz.kalash@ecole.ensicaen.fr](mailto:abdulaziz.kalash@ecole.ensicaen.fr)

---

## Licence MIT
Le projet est sous licence MIT. Le texte de la licence est disponible à la racine du projet.

---

Bonne utilisation !

