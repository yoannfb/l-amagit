<?php
include('includes/header.php'); ?>

<link rel="stylesheet" href="../css/accueil.css">

    <!--Section parallax 1-->
    <section id="parallax1" class="parallax-section">
        <div class="overlay"></div>
        <div class="container h-100">
            <div class="d-flex h-100 align-items-center">
                <!--<div class="parallax-content">
                    <h1 class="title">Mon 1er parallax</h1>
                    <p class="paragraphe">scroller la page</p>
                </div> -->
            </div>
        </div>
    </section>
    <!--Section content-->
    <section id="section1" class="section-content color">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 mx-auto">
                    <h2 class="text-center">BIENVENUE</h2>
                    <p class="paragraphe">Chez L’Âmagit, nous croyons fermement que la guérison vient de l’intérieur.

                        Chaque individu possède en lui des capacités innées de guérison et de transformation.
                        
                        Mon rôle, en tant que thérapeute, est de vous accompagner et de vous guider sur ce chemin, mais c’est vous qui détenez la clé de votre propre bien-être.</p>
                </div>
            </div>
        </div>
    </section>
    <!--Section parallax 2-->
    <section id="parallax2" class="parallax-section">
        <div class="overlay"></div>
        <div class="container h-100">
            <div class="d-flex h-100 align-items-center">
                <!--<div class="parallax-content">
                    <h1 class="title">Mon 1er parallax</h1>
                    <p class="paragraphe">scroller la page</p>
                </div> -->
            </div>
        </div>
    </section>
    <!--Section content-->
    <section id="section1" class="section-content color">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 mx-auto">
                    <h2 class="text-center">BOUDDHA</h2>
                    <p class="paragraphe bouddha">"Nous sommes ce que nous pensons. Tout ce que nous sommes résulte de nos pensées. Avec nos pensées, nous bâtissons notre monde"</p>
                    <p class="d-flex justify-content-end">Bouddha</p>
                </div>
            </div>
        </div>
    </section>
    <section class="col-lg-12 col-md-12 col-sm-12 mx-auto d-flex justify-content-center flex-column text-center color">
        <form action="/contact.php" method="post" novalidate>
        <div class="mb-3 mx-auto col-lg-6 col-md-6">
            <label for="contact_nom" class="form-label">Nom</label>
            <input type="text" class="form-control" id="contact_nom" name="nom" placeholder="" required>
        </div>

        <div class="mb-3 mx-auto col-lg-6 col-md-6">
            <label for="contact_prenom" class="form-label">Prénom</label>
            <input type="text" class="form-control" id="contact_prenom" name="prenom" placeholder="" required>
        </div>

        <div class="mb-3 mx-auto col-lg-6 col-md-6">
            <label for="contact_email" class="form-label">Adresse Email</label>
            <input type="email" class="form-control" id="contact_email" name="email" placeholder="" required>
        </div>

        <div class="mb-3 mx-auto col-lg-6 col-md-6">
            <label for="contact_message" class="form-label">Message</label>
            <textarea class="form-control" id="contact_message" name="message" rows="3" required></textarea>
        </div>

    <!-- Anti-bot (honeypot) -->
        <input type="text" name="website" style="display:none">

        <div class="col-lg-6 col-md-6 mx-auto">
            <button class="btn" type="submit">Soumettre</button>
        </div>
        </form>
    </section>


<script src="../js/accueil.js"></script>

<?php include('includes/footer.php'); ?>