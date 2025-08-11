<?php
// public/contact.php
declare(strict_types=1);

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;

require __DIR__ . '/../vendor/autoload.php';

error_reporting(E_ALL);
ini_set('display_errors', '0'); // laisse à 0 en prod

// 1) Méthode requise
if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
  http_response_code(405);
  exit('Méthode non autorisée');
}

// 2) Anti-bot (honeypot)
if (!empty($_POST['website'] ?? '')) {
  http_response_code(400);
  exit('Requête invalide');
}

// 3) Récupération + validations
$nom       = trim((string)($_POST['name'] ?? $_POST['nom'] ?? ''));
$prenom    = trim((string)($_POST['firstname'] ?? $_POST['prenom'] ?? ''));
$email     = trim((string)($_POST['email'] ?? ''));
$message   = trim((string)($_POST['message'] ?? ''));

if ($nom === '' || $prenom === '' || $email === '' || $message === '') {
  http_response_code(422);
  exit('Tous les champs sont requis.');
}
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
  http_response_code(422);
  exit('Email invalide.');
}
$len = function_exists('mb_strlen') ? mb_strlen($message, 'UTF-8') : strlen($message);
if ($len > 5000) {
  http_response_code(422);
  exit('Message trop long.');
}

// 4) Config SMTP depuis l’environnement (Heroku)
$host       = getenv('MAIL_HOST') ?: getenv('SMTP_HOST') ?: 'smtp.mailgun.org';
$port       = (int)(getenv('MAIL_PORT') ?: getenv('SMTP_PORT') ?: 587);
$encryption = strtolower((string)(getenv('MAIL_ENCRYPTION') ?: getenv('SMTP_SECURE') ?: 'tls'));
$user       = getenv('MAIL_USERNAME') ?: getenv('SMTP_USER') ?: '';
$pass       = getenv('MAIL_PASSWORD') ?: getenv('SMTP_PASS') ?: '';

$fromEmail  = getenv('FROM_EMAIL') ?: $user; // en sandbox Mailgun: souvent postmaster@…sandbox…
$fromName   = getenv('FROM_NAME')  ?: "L'Amagit";
$toEmail    = getenv('TO_EMAIL')   ?: $fromEmail; // destinataire (en sandbox: destinataire autorisé)

$debugOn    = (getenv('DEBUG_EMAIL') === '1');

$mail = new PHPMailer(true);

try {
  // 5) Transport
  $mail->isSMTP();
  $mail->Host       = $host;
  $mail->SMTPAuth   = true;
  $mail->Username   = $user;
  $mail->Password   = $pass;
  $mail->Port       = $port;

  // Sécurité
  if ($encryption === 'ssl' || $port === 465) {
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS; // SMTPS 465
  } else {
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS; // STARTTLS 587
  }

  // Petites options utiles
  $mail->AuthType       = 'PLAIN';   // Mailgun accepte PLAIN après TLS/SSL
  $mail->Timeout        = 15;
  $mail->SMTPKeepAlive  = false;

  if ($debugOn) {
    $mail->SMTPDebug   = SMTP::DEBUG_SERVER;
    $mail->Debugoutput = static function($str, $level){ error_log("SMTP DEBUG: ".$str); };
  }

  // 6) Entêtes & contenu
  $mail->CharSet = 'UTF-8';

  // From : pour Mailgun sandbox, garde une adresse du domaine Mailgun
  $mail->setFrom($fromEmail, $fromName);

  // To : adresse autorisée (sandbox) ou ta destination en prod
  $mail->addAddress($toEmail);

  // Reply-To : l’email du visiteur pour pouvoir répondre
  $mail->addReplyTo($email, $nom.' '.$prenom);

  $mail->Subject = "Nouveau message - $nom $prenom";

  $bodyText = "Nom: $nom\nPrénom: $prenom\nEmail: $email\n\nMessage:\n$message";
  $mail->isHTML(true);
  $mail->Body    = nl2br(htmlspecialchars($bodyText, ENT_QUOTES, 'UTF-8'));
  $mail->AltBody = $bodyText;

  // 7) Envoi
  $mail->send();

  // 8) Succès → redirection
  header('Location: /merci.html', true, 303);
  exit;

} catch (Exception $e) {
  error_log('Email error: ' . $mail->ErrorInfo);

  if ($debugOn) {
    http_response_code(500);
    echo "Erreur d'envoi: " . htmlspecialchars($mail->ErrorInfo);
    exit;
  }

  http_response_code(500);
  exit("Désolé, l'envoi a échoué. Réessayez plus tard.");
}



