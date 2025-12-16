@echo off
SETLOCAL EnableDelayedExpansion
CHCP 65001 >nul

REM Script interactif de déploiement du mode maintenance
REM Pour L'amagit - Windows

cls
echo ╔════════════════════════════════════════════════════════╗
echo ║   MODE MAINTENANCE - L'AMAGIT                          ║
echo ║   Assistant de déploiement interactif                  ║
echo ╚════════════════════════════════════════════════════════╝
echo.

REM Vérifier qu'on est dans le bon dossier
IF NOT EXIST "maintenance.bat" (
    echo [ERREUR] Ce script doit être exécuté depuis le dossier lamagit-maintenance
    echo.
    echo cd C:\chemin\vers\lamagit-maintenance
    pause
    exit /b 1
)

echo [ETAPES A SUIVRE]
echo.
echo 1. Personnaliser vos coordonnées
echo 2. Activer le mode maintenance
echo 3. Déployer sur Heroku
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ETAPE 1/3 : Personnalisation
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo Avant de commencer, vous devez personnaliser vos informations de contact.
echo.
echo Fichier à modifier : public\index.php.maintenance
echo.
echo Cherchez ces lignes (145-146) :
echo   ^<p^>📧 ^<a href="mailto:contact@lamagit.fr"^>contact@lamagit.fr^</a^>^</p^>
echo   ^<p^>📱 Téléphone : [Votre numéro]^</p^>
echo.
echo Et remplacez par vos vraies coordonnées.
echo.

SET /P modifie="Avez-vous modifié le fichier ? (o/n) : "

IF /I NOT "%modifie%"=="o" (
    echo.
    echo [INFORMATION]
    echo.
    echo 1. Ouvrez le fichier : public\index.php.maintenance
    echo 2. Modifiez l'email et le téléphone
    echo 3. Enregistrez le fichier
    echo 4. Relancez ce script
    echo.
    pause
    exit /b 0
)

echo.
echo [OK] Personnalisation OK !
echo.
pause

cls
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ETAPE 2/3 : Activation du mode maintenance
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

SET /P activer="Activer le mode maintenance maintenant ? (o/n) : "

IF /I "%activer%"=="o" (
    echo.
    echo Activation en cours...
    call maintenance.bat on
    
    echo.
    echo [OK] Mode maintenance activé localement !
    echo.
) ELSE (
    echo.
    echo [ANNULATION] Activation annulée
    pause
    exit /b 0
)

pause

cls
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ETAPE 3/3 : Déploiement sur Heroku
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo Nous allons maintenant déployer sur Heroku.
echo.
echo Commandes qui seront exécutées :
echo   1. git add .
echo   2. git commit -m "Activation du mode maintenance"
echo   3. git push heroku main
echo.

SET /P deployer="Continuer avec le déploiement ? (o/n) : "

IF /I NOT "%deployer%"=="o" (
    echo.
    echo [ANNULATION] Déploiement annulé
    echo.
    echo Le mode maintenance est activé localement.
    echo Pour déployer manuellement plus tard :
    echo.
    echo   git add .
    echo   git commit -m "Activation du mode maintenance"
    echo   git push heroku main
    echo.
    pause
    exit /b 0
)

echo.
echo Déploiement en cours...
echo.

REM Git add
echo git add ...
git add .

REM Git commit
echo git commit ...
git commit -m "Activation du mode maintenance"

REM Git push
echo git push heroku main ...
echo.
git push heroku main

IF %ERRORLEVEL% EQU 0 (
    echo.
    echo ╔════════════════════════════════════════════════════════╗
    echo ║                   [SUCCES] !                           ║
    echo ╚════════════════════════════════════════════════════════╝
    echo.
    echo Votre site affiche maintenant la page de maintenance.
    echo.
    echo Vérifiez votre site maintenant !
    echo.
    
    SET /P ouvrir="Voulez-vous ouvrir votre site ? (o/n) : "
    IF /I "!ouvrir!"=="o" (
        SET /P appname="Nom de votre app Heroku : "
        IF NOT "!appname!"=="" (
            heroku open --app !appname!
        )
    )
) ELSE (
    echo.
    echo [ERREUR] Erreur lors du déploiement
    echo.
    echo Vérifiez :
    echo   - Que vous êtes bien connecté à Heroku ^(heroku login^)
    echo   - Que le remote 'heroku' est bien configuré
    echo   - Les logs avec : heroku logs --tail
    echo.
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo Pour plus d'infos :
echo   - PERSONNALISATION_COMPLETE.md
echo   - GUIDE_RAPIDE.md
echo.
echo Pour désactiver plus tard :
echo   maintenance.bat off
echo   git add . ^&^& git commit -m "Fin maintenance" ^&^& git push heroku main
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
pause
