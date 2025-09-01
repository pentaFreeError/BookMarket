document.getElementById("search-authors").addEventListener("keyup", function() {
    let searchValue = this.value.trim();

    if(searchValue == "") {
        let leftPanel = document.getElementById("results-authors");
        leftPanel.innerHTML = "Résultats des auteurs...";
        return;
    }

    if (searchValue.length < 2) return; 

    let xhr = new XMLHttpRequest();
    xhr.open("GET", "recherche_auteurs.php?debnom=" + encodeURIComponent(searchValue), true);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            let authors = JSON.parse(xhr.responseText);
            affiche_auteurs(authors);
        }
    };

    xhr.send();
});

function affiche_auteurs(authors) {
    let leftPanel = document.getElementById("results-authors");
    leftPanel.innerHTML = ""; 

    if(authors.length == 0) {
        let p = document.createElement("p");
        p.innerHTML = "No author's name starts with this.";
        leftPanel.appendChild(p);
        return;
    }

    let ol = document.createElement("ol");
    authors.forEach(author => {
        let li = document.createElement("li");
        li.innerHTML = `<a href="#" onclick="recherche_ouvrages_auteur(${author.code})">${author.nom} ${author.prenom}</a>`;
        ol.appendChild(li);
    });

    leftPanel.appendChild(ol);
}

document.getElementById("search-books").addEventListener("keyup", function() {
    let searchValue = this.value.trim();

    if(searchValue == "") {
        let rightPanel = document.getElementById("results-books");
        rightPanel.innerHTML = "Résultats des ouvrages...";
        return;
    }

    if (searchValue.length < 2) return; 

    recherche_ouvrages_titre(searchValue);
});

function recherche_ouvrages_titre(debtitre) {
    let xhr = new XMLHttpRequest();
    xhr.open("GET", "recherche_ouvrages_titre.php?debtitre=" + encodeURIComponent(debtitre), true);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            let books = JSON.parse(xhr.responseText);
            affiche_ouvrages(books);
        }
    };

    xhr.send();
}

function affiche_ouvrages(books) {
    let rightPanel = document.getElementById("results-books");
    rightPanel.innerHTML = ""; 

    if(books.length == 0) {
        let p = document.createElement("p");
        p.innerHTML = "No title's starts with this.";
        rightPanel.appendChild(p);
        return;
    }

    let ol = document.createElement("ol");

    books.forEach(book => {
        let li = document.createElement("li");
        li.textContent = book.nom; 

        let ul = document.createElement("ul"); 

        book.exemplaires.forEach(ex => {
            let liEx = document.createElement("li");

            let btnCommander = document.createElement("button");
            btnCommander.textContent = "Ajouter au panier";
            btnCommander.style.marginLeft = "40px"; 

            btnCommander.addEventListener("click", function () {
                let formData = new FormData();
                formData.append("code", ex.code);

                fetch("add_to_panier.php", {
                    method: "POST",
                    body: formData
                })
                .then(response => response.json()) 
                .then(data => {
                    if (data.status === "success") {
                        alert("Article ajouté au panier !");
                    } else {
                        alert("Erreur lors de l'ajout au panier !");
                    }
                })
                .catch(error => console.error("Erreur:", error));
            });

            liEx.textContent = `-  ${ex.nom}, ${ex.prix} euros  _`; 
            liEx.appendChild(btnCommander)
            
            ul.appendChild(liEx);
        });

        li.appendChild(document.createElement("br"));
        li.appendChild(document.createElement("br"));
        li.appendChild(document.createElement("br"));
        li.appendChild(ul); 
        li.appendChild(document.createElement("hr"));
        ol.appendChild(li);
    });

    rightPanel.appendChild(ol);
}

function recherche_ouvrages_auteur(code) {
    let xhr = new XMLHttpRequest();
    xhr.open("GET", "recherche_ouvrages_auteur.php?code=" + encodeURIComponent(code), true);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            let books = JSON.parse(xhr.responseText);
            affiche_ouvrages(books);
        }
    };

    xhr.send();
}