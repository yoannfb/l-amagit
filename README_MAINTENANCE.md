# Mode Maintenance pour L'amagit

Ce guide vous explique comment mettre votre site en mode maintenance et le réactiver.

## 📋 Méthode Simple (Recommandée)

### Pour ACTIVER le mode maintenance :

```bash
# 1. Remplacer index.php par la version maintenance
mv public/index.php.backup public/index.php.old
mv public/index.php.maintenance public/index.php
```

### Pour DÉSACTIVER le mode maintenance :

```bash
# 1. Restaurer l'index.php original
mv public/index.php public/index.php.maintenance
mv public/index.php.old public/index.php
```

## 🚀 Déploiement sur Heroku

### Étape 1 : Activer le mode maintenance localement

```bash
cd /chemin/vers/votre/projet
mv public/index.php public/index.php.old
mv public/index.php.maintenance public/index.php
```

### Étape 2 : Commit et push vers Heroku

```bash
git add .
git commit -m "Activation du mode maintenance"
git push heroku main
```

### Étape 3 : Pour désactiver plus tard

```bash
mv public/index.php public/index.php.maintenance
mv public/index.php.old public/index.php
git add .
git commit -m "Désactivation du mode maintenance"
git push heroku main
```

## 📝 Personnalisation

Vous pouvez personnaliser la page de maintenance en modifiant :
- **public/index.php.maintenance** : Le fichier de la page de maintenance
- Changez le texte, les couleurs, les informations de contact

### Exemple de personnalisation :

```php
// Dans index.php.maintenance, modifiez :
<p>📧 <a href="mailto:VOTRE-EMAIL@example.com">VOTRE-EMAIL@example.com</a></p>
<p>📱 Téléphone : 06 XX XX XX XX</p>
```

## 🔧 Alternative : Mode maintenance Heroku natif

Heroku propose aussi un mode maintenance intégré :

```bash
# Activer
heroku maintenance:on --app votre-nom-app

# Désactiver
heroku maintenance:off --app votre-nom-app

# Vérifier le statut
heroku maintenance --app votre-nom-app
```

⚠️ **Note** : Le mode maintenance Heroku utilise une page générique. 
Notre solution personnalisée offre un design plus professionnel.

## 📦 Fichiers créés

- `public/index.php.maintenance` : Page de maintenance personnalisée
- `public/index.php.backup` : Sauvegarde de votre index.php original
- `public/maintenance.php` : Alternative (page standalone)
- `public/.htaccess.maintenance` : Configuration Apache (alternative)

## ⚠️ Important

- Toujours faire un backup avant de modifier les fichiers
- Testez en local avant de déployer sur Heroku
- La page de maintenance envoie un code HTTP 503 (Service Unavailable)
- Les moteurs de recherche comprendront que c'est temporaire

## 🎨 Variantes de messages

Voici quelques suggestions de messages pour la page de maintenance :

1. **Court et simple** : "Nous faisons peau neuve et nous revenons très vite !"
2. **Avec timing** : "Maintenance en cours. Retour prévu dans 2 heures."
3. **Avec excuse** : "Désolé pour le dérangement. Nous améliorons votre expérience !"
4. **Créatif** : "Notre site fait une pause bien-être... Comme nous ! 🧘‍♀️"

## 🆘 Support

En cas de problème :
1. Vérifiez que tous les fichiers sont bien en place
2. Consultez les logs Heroku : `heroku logs --tail --app votre-nom-app`
3. Restaurez la version précédente si nécessaire

---

Créé pour L'amagit - Site de bien-être et soins
