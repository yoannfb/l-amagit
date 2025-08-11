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
    $mail->addAddress($toEmail);

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
