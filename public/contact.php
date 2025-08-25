<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require __DIR__ . '/../vendor/autoload.php';

// Récupération des variables d'environnement (Heroku Config Vars)
$mailHost     = getenv('MAIL_HOST');
$mailPort     = getenv('MAIL_PORT');
$mailUsername = getenv('MAIL_USERNAME');
$mailPassword = getenv('MAIL_PASSWORD');
$mailEncryption = getenv('MAIL_ENCRYPTION') ?: 'tls';
$toEmail      = getenv('TO_EMAIL') ?: 'ton-email-de-test@example.com';

// Vérification de base
if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    http_response_code(405);
    exit('Méthode non autorisée');
}

// Sécurité basique (honeypot)
if (!empty($_POST['website'])) {
    exit('Spam détecté.');
}

// Nettoyage des données
$nom      = htmlspecialchars(trim($_POST['nom'] ?? ''));
$prenom   = htmlspecialchars(trim($_POST['prenom'] ?? ''));
$email    = filter_var(trim($_POST['email'] ?? ''), FILTER_VALIDATE_EMAIL);
$message  = htmlspecialchars(trim($_POST['message'] ?? ''));

if (!$nom || !$prenom || !$email || !$message) {
    exit('Tous les champs sont obligatoires.');
}

try {
    $mail = new PHPMailer(true);
    
    $mail->SMTPDebug = 2; // Affiche les échanges avec le serveur SMTP
    $mail->Debugoutput = 'error_log'; // Envoie les logs dans error_log PHP

    $mail->isSMTP();
    $mail->Host       = $mailHost;
    $mail->SMTPAuth   = true;
    $mail->Username   = $mailUsername;
    $mail->Password   = $mailPassword;
    $mail->SMTPSecure = $mailEncryption;
    $mail->Port       = $mailPort;

    // Expéditeur
    $mail->setFrom($mailUsername, 'Formulaire de contact');
    $mail->addReplyTo($email, "$prenom $nom");

    // Destinataire
    // --- DESTINATAIRE (modifiable via variable d'environnement) ---
$toEmail = getenv('TO_EMAIL');              // ← lira TO_EMAIL depuis Heroku
if (!$toEmail) {
    // sécurité/fallback (à personnaliser si tu veux un secours)
    $toEmail = 'ton.destinataire@exemple.com';
}

// From = adresse de ton domaine Mailgun (NE PAS mettre l'email du visiteur)
$mail->setFrom('postmaster@sandbox0b4f3aaed1c14fe2b3386e89e69d8dc4.mailgun.org', 'Formulaire Contact');

// Reply-To = l’email de la personne qui a rempli le formulaire
// Adapte les champs POST si tes <input> s’appellent différemment
$fromEmail = isset($_POST['email']) ? trim($_POST['email']) : '';
$fromName  = isset($_POST['name']) ? trim($_POST['name']) : 'Visiteur';

if (filter_var($fromEmail, FILTER_VALIDATE_EMAIL)) {
    $mail->addReplyTo($fromEmail, $fromName);
}

// Destinataire final
$mail->addAddress($toEmail, 'Destinataire');


    // Contenu
    $mail->isHTML(true);
    $mail->Subject = "Nouveau message de $prenom $nom";
    $mail->Body    = "
        <h3>Nouvelle demande de contact</h3>
        <p><strong>Nom :</strong> $nom</p>
        <p><strong>Prénom :</strong> $prenom</p>
        <p><strong>Email :</strong> $email</p>
        <p><strong>Message :</strong><br>" . nl2br($message) . "</p>
    ";

    if ($mail->send()) {
        echo 'Message envoyé avec succès.';
    } else {
        echo 'Échec de l\'envoi du message.';
    }
} catch (Exception $e) {
    error_log("Erreur d'envoi : " . $mail->ErrorInfo);
    echo "Erreur d'envoi : " . $mail->ErrorInfo;
}
