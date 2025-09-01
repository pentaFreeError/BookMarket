const params = new URLSearchParams(window.location.search);

if (params.has("error")) {
    let errorMessage = "";
    
    switch (params.get("error")) {
        case "Email":
            errorMessage = "❌ L'email fourni n'est pas valide.";
            break;
        case "Password":
            errorMessage = "❌ Le mot de passe n'est pas valide.";
            break;
        case "notFound":
            errorMessage = "❌ Utilisateur non trouvé. Vérifiez votre email et votre mot de passe.";
            break;
        case "nom" :
            errorMessage = "❌ Le nom n'est pas valide.";
            break;
        case "prenom" :
            errorMessage = "❌ Le prenom n'est pas valide.";
            break;
        case "adresse" :
            errorMessage = "❌ L'adresse n'est pas valide.";
            break;
        case "telephone" :
            errorMessage = "❌ Le telephone n'est pas valide.";
            break;
        case "mailExist" :
            errorMessage = "❌ Le Email est deja utilisé.";
            break;
        case "saved" :
            errorMessage = "L'utilisateur a bien été enregistré.";
            break;
        case "loginFirst" :
            errorMessage = "Il faut login avant d'acceder à cette page (session expiré).";
            break;
        case "loggedOut" :
            errorMessage = "Vous avez bien été déconnecté.";
            break;
        case "database" :
            errorMessage = "Erreur de connection à la base de donnée.";
            break;
        default:
            errorMessage = "❌ Une erreur inconnue est survenue.";
    }

    alert(errorMessage);

    window.history.replaceState({}, document.title, window.location.pathname);
}


document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("register-btn").addEventListener("click", function (event) {
        if (validateRegisterForm()) {
            document.getElementById("register-form").submit();
        }
    });

    document.getElementById("login-btn").addEventListener("click", function (event) {
        if (validateLoginForm()) {
            document.getElementById("login-form").submit();
        }
    });
});

function validateRegisterForm() {
    let fields = [
        { id: "nom", errorId: "error-nom", validate: validateName, message: "Le nom ne doit contenir que des lettres." },
        { id: "prenom", errorId: "error-prenom", validate: validateName, message: "Le prénom ne doit contenir que des lettres." },
        { id: "adresse", errorId: "error-adresse", message: "L'adresse est obligatoire." },
        { id: "ville", errorId: "error-ville", validate: validateCity, message: "La ville ne doit contenir que des lettres." },
        { id: "pays", errorId: "error-pays", validate: validateCountry, message: "Le pays ne doit contenir que des lettres." },
        { id: "code_postal", errorId: "error-postal", validate: validatePostalCode, message: "Le code postal doit contenir uniquement des chiffres (4 à 10 caractères)." },
        { id: "email", errorId: "error-email", validate: validateEmail, message: "L'email est invalide." },
        { id: "password", errorId: "error-password", validate: validatePassword, message: "Le mot de passe doit contenir au moins 8 caractères, 1 majuscule, 1 chiffre et 1 caractère spécial." }
    ];

    return validateForm(fields);
}

function validateLoginForm() {
    let fields = [
        { id: "login-email", errorId: "error-login-email", validate: validateEmail, message: "L'email est invalide." },
        { id: "login-password", errorId: "error-login-password", validate: validatePassword, message: "Le mot de passe doit contenir au moins 8 caractères, 1 majuscule, 1 chiffre et 1 caractère spécial." }
    ];

    return validateForm(fields);
}

function validateForm(fields) {
    let firstErrorField = null;

    for (let field of fields) {
        let input = document.getElementById(field.id);
        let error = document.getElementById(field.errorId);

        if (field.validate) {
            if (!field.validate(input.value)) {
                firstErrorField = input;
                showError(input, error, field.message);
                break; 
            } else {
                hideError(input, error);
            }
        } else {
            if (input.value.trim() === "") {
                firstErrorField = input;
                showError(input, error, field.message);
                break; 
            } else {
                hideError(input, error);
            }
        }
    }

    if (firstErrorField) {
        firstErrorField.focus();
        return false;
    }

    return true;
}


function validateName(name) {
    let regex = /^[A-Za-zÀ-ÖØ-öø-ÿ\s-]+$/;
    return regex.test(name);
}

function validateCity(city) {
    return validateName(city); 
}

function validateCountry(country) {
    return validateName(country); 
}

function validatePostalCode(postalCode) {
    let regex = /^[0-9]{4,10}$/; 
    return regex.test(postalCode);
}

function validateEmail(email) {
    let regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
}

function validatePassword(password) {
    return (
        password.length >= 8 &&
        /[A-Z]/.test(password) &&
        /[a-z]/.test(password) &&
        /\d/.test(password) &&
        /[@$!%#*?&]/.test(password)
    );
}

function showError(input, error, message) {
    input.classList.add("error");
    error.innerText = message;
    error.style.visibility = "visible";
}

function hideError(input, error) {
    input.classList.remove("error");
    error.innerText = "";
    error.style.visibility = "hidden";
}
