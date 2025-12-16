#!/bin/bash

# Script de gestion du mode maintenance pour L'amagit
# Usage: ./maintenance.sh [on|off|status]

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PUBLIC_DIR="$SCRIPT_DIR/public"

# Couleurs pour l'affichage
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function show_status() {
    if [ -f "$PUBLIC_DIR/index.php.old" ]; then
        echo -e "${YELLOW}Mode maintenance: ACTIVÉ${NC}"
        echo "Le site affiche actuellement la page de maintenance."
    else
        echo -e "${GREEN}Mode maintenance: DÉSACTIVÉ${NC}"
        echo "Le site fonctionne normalement."
    fi
}

function activate_maintenance() {
    if [ -f "$PUBLIC_DIR/index.php.old" ]; then
        echo -e "${YELLOW}Le mode maintenance est déjà activé.${NC}"
        return 1
    fi
    
    echo "🔧 Activation du mode maintenance..."
    
    # Sauvegarder l'index actuel
    if [ -f "$PUBLIC_DIR/index.php" ]; then
        mv "$PUBLIC_DIR/index.php" "$PUBLIC_DIR/index.php.old"
        echo "✓ Sauvegarde de index.php -> index.php.old"
    fi
    
    # Copier la version maintenance
    if [ -f "$PUBLIC_DIR/index.php.maintenance" ]; then
        cp "$PUBLIC_DIR/index.php.maintenance" "$PUBLIC_DIR/index.php"
        echo "✓ Activation de index.php.maintenance"
    else
        echo -e "${RED}Erreur: index.php.maintenance introuvable${NC}"
        # Restaurer si erreur
        if [ -f "$PUBLIC_DIR/index.php.old" ]; then
            mv "$PUBLIC_DIR/index.php.old" "$PUBLIC_DIR/index.php"
        fi
        return 1
    fi
    
    echo -e "${GREEN}✓ Mode maintenance activé avec succès !${NC}"
    echo ""
    echo "Pour déployer sur Heroku :"
    echo "  git add ."
    echo "  git commit -m 'Activation du mode maintenance'"
    echo "  git push heroku main"
}

function deactivate_maintenance() {
    if [ ! -f "$PUBLIC_DIR/index.php.old" ]; then
        echo -e "${YELLOW}Le mode maintenance n'est pas activé.${NC}"
        return 1
    fi
    
    echo "🔓 Désactivation du mode maintenance..."
    
    # Supprimer la version maintenance active
    if [ -f "$PUBLIC_DIR/index.php" ]; then
        rm "$PUBLIC_DIR/index.php"
        echo "✓ Suppression de index.php (version maintenance)"
    fi
    
    # Restaurer l'original
    if [ -f "$PUBLIC_DIR/index.php.old" ]; then
        mv "$PUBLIC_DIR/index.php.old" "$PUBLIC_DIR/index.php"
        echo "✓ Restauration de index.php.old -> index.php"
    fi
    
    echo -e "${GREEN}✓ Mode maintenance désactivé avec succès !${NC}"
    echo ""
    echo "Pour déployer sur Heroku :"
    echo "  git add ."
    echo "  git commit -m 'Désactivation du mode maintenance'"
    echo "  git push heroku main"
}

# Menu principal
case "$1" in
    on|activate)
        activate_maintenance
        ;;
    off|deactivate)
        deactivate_maintenance
        ;;
    status)
        show_status
        ;;
    *)
        echo "Usage: $0 {on|off|status}"
        echo ""
        echo "Commandes:"
        echo "  on      - Activer le mode maintenance"
        echo "  off     - Désactiver le mode maintenance"
        echo "  status  - Afficher l'état actuel"
        echo ""
        show_status
        exit 1
        ;;
esac
