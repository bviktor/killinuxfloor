#!/bin/bash

set -eu

read -p $'This will uninstall killinuxfloor from this machine. Press \e[36my\e[0m to continue: ' -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo 'Uninstallation cancelled.'
    exit
fi

export ROOT="${BASH_SOURCE%/*}"

# globals
export STEAM_HOME='/home/steam'
export SKIP_KFGAME=0

# aliases
export ECHO_DONE='echo -e \e[32mdone\e[0m.'

# Helper
echo -n 'Removing helpers... '
# Legacy
rm -rf ${STEAM_HOME}/kf2-centos
rm -rf ${STEAM_HOME}/killinuxfloor
rm -rf ${STEAM_HOME}/bin
${ECHO_DONE}

# Autokick
echo -n 'Removing auto-kick bot... '
rm -rf ${STEAM_HOME}/kf2autokick
${ECHO_DONE}

# Backup
DATE_STR=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="${STEAM_HOME}/Config-${DATE_STR}.tgz"
echo -ne "Backing up current KF2 config as \e[36m${BACKUP_FILE}\e[0m... "
rm -f ${STEAM_HOME}/Config/Internal
sudo -u steam sh -c "tar czfh ${BACKUP_FILE} -C ${STEAM_HOME} Config"
${ECHO_DONE}

# Steam + KF2
echo -n 'Removing KF2 and Steam... '
if [ ${SKIP_KFGAME} -ne 1 ]
then
    rm -rf ${STEAM_HOME}/Steam
    rm -rf ${STEAM_HOME}/.steam
fi
rm -f ${STEAM_HOME}/Cache
rm -f ${STEAM_HOME}/Workshop
${ECHO_DONE}

echo -e "\e[32mkillinuxfloor successfully uninstalled.\e[0m"
