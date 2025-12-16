#!/bin/bash

# Script interactif de déploiement du mode maintenance
# Pour L'amagit

clear
echo "╔════════════════════════════════════════════════════════╗"
echo "║   MODE MAINTENANCE - L'AMAGIT                          ║"
echo "║   Assistant de déploiement interactif                  ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Vérifier qu'on est dans le bon dossier
if [ ! -f "maintenance.sh" ]; then
    echo -e "${RED}❌ Erreur: Ce script doit être exécuté depuis le dossier lamagit-maintenance${NC}"
    echo "cd /chemin/vers/lamagit-maintenance"
    exit 1
fi

# Fonction de pause
pause() {
    echo ""
    read -p "Appuyez sur ENTRÉE pour continuer..."
    echo ""
}

echo -e "${BLUE}📋 ÉTAPES À SUIVRE :${NC}"
echo ""
echo "1. Personnaliser vos coordonnées"
echo "2. Activer le mode maintenance"
echo "3. Déployer sur Heroku"
echo ""

# ÉTAPE 1
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}ÉTAPE 1/3 : Personnalisation${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Avant de commencer, vous devez personnaliser vos informations de contact."
echo ""
echo "📝 Fichier à modifier : public/index.php.maintenance"
echo ""
echo "Cherchez ces lignes (145-146) :"
echo "  <p>📧 <a href=\"mailto:contact@lamagit.fr\">contact@lamagit.fr</a></p>"
echo "  <p>📱 Téléphone : [Votre numéro]</p>"
echo ""
echo "Et remplacez par vos vraies coordonnées."
echo ""
read -p "Avez-vous modifié le fichier ? (o/n) : " response

if [[ ! "$response" =~ ^[oO]$ ]]; then
    echo ""
    echo -e "${YELLOW}⚠️  Pas de problème !${NC}"
    echo ""
    echo "1. Ouvrez le fichier : public/index.php.maintenance"
    echo "2. Modifiez l'email et le téléphone"
    echo "3. Enregistrez le fichier"
    echo "4. Relancez ce script"
    echo ""
    exit 0
fi

echo -e "${GREEN}✓ Personnalisation OK !${NC}"
pause

# ÉTAPE 2
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}ÉTAPE 2/3 : Activation du mode maintenance${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -p "Activer le mode maintenance maintenant ? (o/n) : " response

if [[ "$response" =~ ^[oO]$ ]]; then
    echo ""
    echo "🔧 Activation en cours..."
    ./maintenance.sh on
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✓ Mode maintenance activé localement !${NC}"
    else
        echo ""
        echo -e "${RED}❌ Erreur lors de l'activation${NC}"
        exit 1
    fi
else
    echo ""
    echo -e "${YELLOW}⚠️  Activation annulée${NC}"
    exit 0
fi

pause

# ÉTAPE 3
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}ÉTAPE 3/3 : Déploiement sur Heroku${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Nous allons maintenant déployer sur Heroku."
echo ""
echo "Commandes qui seront exécutées :"
echo "  1. git add ."
echo "  2. git commit -m \"Activation du mode maintenance\""
echo "  3. git push heroku main"
echo ""
read -p "Continuer avec le déploiement ? (o/n) : " response

if [[ ! "$response" =~ ^[oO]$ ]]; then
    echo ""
    echo -e "${YELLOW}⚠️  Déploiement annulé${NC}"
    echo ""
    echo "Le mode maintenance est activé localement."
    echo "Pour déployer manuellement plus tard :"
    echo ""
    echo "  git add ."
    echo "  git commit -m \"Activation du mode maintenance\""
    echo "  git push heroku main"
    echo ""
    exit 0
fi

echo ""
echo "📤 Déploiement en cours..."
echo ""

# Git add
echo "➜ git add ..."
git add .

# Git commit
echo "➜ git commit ..."
git commit -m "Activation du mode maintenance"

# Git push
echo "➜ git push heroku main ..."
echo ""
git push heroku main

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                   ✓ SUCCÈS !                           ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Votre site affiche maintenant la page de maintenance."
    echo ""
    echo "🌐 Vérifiez votre site maintenant !"
    echo ""
    
    read -p "Voulez-vous ouvrir votre site ? (o/n) : " response
    if [[ "$response" =~ ^[oO]$ ]]; then
        read -p "Nom de votre app Heroku : " appname
        if [ ! -z "$appname" ]; then
            heroku open --app "$appname"
        fi
    fi
    
else
    echo ""
    echo -e "${RED}❌ Erreur lors du déploiement${NC}"
    echo ""
    echo "Vérifiez :"
    echo "  - Que vous êtes bien connecté à Heroku (heroku login)"
    echo "  - Que le remote 'heroku' est bien configuré"
    echo "  - Les logs avec : heroku logs --tail"
    echo ""
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📚 Pour plus d'infos :"
echo "  - PERSONNALISATION_COMPLETE.md"
echo "  - GUIDE_RAPIDE.md"
echo ""
echo "🔄 Pour désactiver plus tard :"
echo "  ./maintenance.sh off"
echo "  git add . && git commit -m \"Fin maintenance\" && git push heroku main"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
