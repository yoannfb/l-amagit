@echo off
REM Script de gestion du mode maintenance pour L'amagit (Windows)

SETLOCAL EnableDelayedExpansion

SET PUBLIC_DIR=public

IF "%1"=="" GOTO show_help
IF "%1"=="on" GOTO activate
IF "%1"=="off" GOTO deactivate
GOTO show_help

:show_help
echo.
echo Usage: maintenance.bat [on^|off]
echo.
echo Commandes:
echo   on  - Activer le mode maintenance
echo   off - Desactiver le mode maintenance
echo.
GOTO end

:activate
echo.
echo Activation du mode maintenance...
echo.

IF EXIST "%PUBLIC_DIR%\index.php.old" (
    echo Le mode maintenance est deja active.
    GOTO end
)

IF EXIST "%PUBLIC_DIR%\index.php" (
    move "%PUBLIC_DIR%\index.php" "%PUBLIC_DIR%\index.php.old" >nul
    echo [OK] Sauvegarde de index.php
)

IF EXIST "%PUBLIC_DIR%\index.php.maintenance" (
    copy "%PUBLIC_DIR%\index.php.maintenance" "%PUBLIC_DIR%\index.php" >nul
    echo [OK] Activation de index.php.maintenance
) ELSE (
    echo [ERREUR] index.php.maintenance introuvable
    IF EXIST "%PUBLIC_DIR%\index.php.old" (
        move "%PUBLIC_DIR%\index.php.old" "%PUBLIC_DIR%\index.php" >nul
    )
    GOTO end
)

echo.
echo [SUCCESS] Mode maintenance active !
echo.
echo Pour deployer sur Heroku:
echo   git add .
echo   git commit -m "Activation du mode maintenance"
echo   git push heroku main
echo.
GOTO end

:deactivate
echo.
echo Desactivation du mode maintenance...
echo.

IF NOT EXIST "%PUBLIC_DIR%\index.php.old" (
    echo Le mode maintenance n'est pas active.
    GOTO end
)

IF EXIST "%PUBLIC_DIR%\index.php" (
    del "%PUBLIC_DIR%\index.php"
    echo [OK] Suppression de index.php (version maintenance)
)

IF EXIST "%PUBLIC_DIR%\index.php.old" (
    move "%PUBLIC_DIR%\index.php.old" "%PUBLIC_DIR%\index.php" >nul
    echo [OK] Restauration de index.php
)

echo.
echo [SUCCESS] Mode maintenance desactive !
echo.
echo Pour deployer sur Heroku:
echo   git add .
echo   git commit -m "Desactivation du mode maintenance"
echo   git push heroku main
echo.
GOTO end

:end
pause