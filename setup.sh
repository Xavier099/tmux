#!/usr/bin/sh

termux-setup-storage

apt update
apt upgrade -y

apt install git openssh -y

GIT_USERNAME="$(git config --get user.name)"
GIT_EMAIL="$(git config --get user.email)"
echo "Configuring git"
if [[ -z ${GIT_USERNAME} ]]; then
    echo -n "Enter your name: "
    read -r NAME
    git config --global user.name "${NAME}"
fi
if [[ -z ${GIT_EMAIL} ]]; then
    echo -n "Enter your email: "
    read -r EMAIL
    git config --global user.email "${EMAIL}"
fi
git config --global core.editpr "nano"
git config --global credential.helper "cache --timeout=7200"
echo "git identity setup successfully!"

