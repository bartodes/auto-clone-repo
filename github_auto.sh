#!/bin/bash


<<com
Automatizacion para clonar todos los repositorios que cuelguen de un usuario de github.

Debemos usar: curl 'https://api.github.com/users/*/repos -H "Accept: application/vnd.github+json"|grep -e 'clone_url*' | cut -d \" -f 4'

Condicionalmente, debemos dicernir si ademas de los que el usuario tenga publicos querramos clonar los que esten privados. Para esto debemos manipular Tokens.
com


function clonarRepoConToken() {
    read -p ' Nombre del usuario de GitHub: ' USER
    read -p ' Token para el acceso a sus repositorios: ' TOKEN
    REPOS=($(curl -s https://api.github.com/users/$USER/repos -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $TOKEN" | grep -e 'clone_url*' | cut -d \" -f 4))
    for i in ${REPOS[@]};
    do
        git clone $i
    done 
}


function clonarRepo() {
    read -p ' Nombre del usuario de GitHub: ' USER
    REPOS=($(curl -s https://api.github.com/users/$USER/repos -H "Accept: application/vnd.github+json"|grep -e 'clone_url*' | cut -d \" -f 4))
    for i in ${REPOS[@]}
    do
        git clone $i 
    done
}


function menu() {
    echo -e '\n¡Vayamos a clonar los repositorios de un usuario! Pero primero: '
    echo -e '\n¿Necesito un acceso vía Token para realizar la clonación de todos los repositorios del usuario?\n'
    echo ' 1) No'
    echo ' 2) Si'
    echo -ne '\n Elija una opción: '
    read OPTION 
    case $OPTION in
    1) clonarRepo;;
    2) clonarRepoConToken;;
    *) echo -e 'Usted ha elejido una opción invalida.\nPor favor intentelo de nuevo.' ;;
    esac
}


function verificarGit() {
    if [ -f /usr/bin/git ]; then
        menu
    else
        echo -e '\nGit no esta instalado. \n'
        exit
    fi 
}


function main() {
    verificarGit
}
main