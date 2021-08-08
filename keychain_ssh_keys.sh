#!/bin/bash

cd `dirname $0`

SHELL_RC_FILE_PATH=$HOME/.bashrc
SRC_FILE_PATH=./file/keychain_ssh_keys
DST_FILE_PATH=/etc/keychain_ssh_keys

sudo cp -f "${SRC_FILE_PATH}" "${DST_FILE_PATH}"

cat "${SHELL_RC_FILE_PATH}" | grep ". ${DST_FILE_PATH}" >/dev/null
if [ $? -ne 0 ]; then
    echo -n "\n" >> "${SHELL_RC_FILE_PATH}"
    echo ". ${DST_FILE_PATH}" >> "${SHELL_RC_FILE_PATH}"
fi

. "${SHELL_RC_FILE_PATH}"

sudo apt list --installed | grep "keychain" >/dev/null
KEYCHAIN_INSTALLED=$?
sudo apt list --installed | grep "ssh-askpass" >/dev/null
SSH_ASKPASS_INSTALLED=$?
if [ ${KEYCHAIN_INSTALLED} -eq 0 -a ${SSH_ASKPASS_INSTALLED} -eq 0 ]; then
    exit 0
fi

sudo apt -y update
if [ ${KEYCHAIN_INSTALLED} -ne 0 ]; then
    sudo apt -y install keychain
fi
if [ ${SSH_ASKPASS_INSTALLED} -ne 0 ]; then
    sudo apt -y install ssh-askpass
fi

exit 0
