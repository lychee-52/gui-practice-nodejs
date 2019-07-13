#!/bin/bash

set -e

GPGUSER="Norifumi Goto"
KEYDBDIR="$HOME/etc/password"

while getopts "edl" opt; do
    case $opt in
	e) MODE="encrypt"; ;;
	d) MODE="decrypt"; ;;
	l) MODE="list"; ;;
    esac
done

function encrypt() {
    read -p "enter your user id:" USERID
    echo "USERID=$USERID"
    read -s -p "enter your password:" PASSWORD
    echo
    if [ -z "$PASSWORD" ]; then
	echo "ERROR: empty password is not allowed" >&2
	return 1
    fi
    read -s -p "enter your password again:" PASSWORD2
    echo
    if [ "x$PASSWORD" != "x$PASSWORD2" ]; then
	echo "ERROR: password mismatch" >&2
	return 1
    fi
    echo $PASSWORD | gpg -e -r "${GPGUSER}" > ${KEYDBDIR}/${USERID}.gpg
    return 0
}

function decrypt() {
    read -p "enter your user id:" USERID
    echo "USERID=$USERID"
    if [ ! -f ${KEYDBDIR}/${USERID}.gpg ]; then
	echo "ERROR: password for ${USERID} not found" >&2
	return 1
    fi
    cat ${KEYDBDIR}/${USERID}.gpg | gpg -d 2>/dev/null
}

function list_id() {
    if ls ${KEYDBDIR}/*.gpg >/dev/null; then
	for f in ${KEYDBDIR}/*.gpg; do
	    basename $f .gpg
	done
    else
	echo "<no passwords registered>"
    fi
}

if   [ "x$MODE" = "xencrypt" ]; then
    encrypt
elif [ "x$MODE" = "xdecrypt" ]; then
    decrypt
elif [ "x$MODE" = "xlist" ]; then
    list_id
fi
exit 0
