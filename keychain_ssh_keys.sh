#!/bin/bash

cd `dirname $0`

SHELL_RC_FILE_PATH=$HOME/.bashrc
SRC_FILE_PATH=./file/keychain_ssh_keys
DST_FILE_PATH=/etc/keychain_ssh_keys

dpkg -l keychain | grep -E "^ii( )+keychain" >/dev/null
if [ $? -ne 0 ]; then
    sudo apt -y install keychain
fi
dpkg -l ssh-askpass | grep -E "^ii( )+ssh-askpass" >/dev/null
if [ $? -ne 0 ]; then
    sudo apt -y install ssh-askpass
fi

sudo cp -f "${SRC_FILE_PATH}" "${DST_FILE_PATH}"

cat "${SHELL_RC_FILE_PATH}" | grep -E "^. ${DST_FILE_PATH}" >/dev/null
if [ $? -ne 0 ]; then
    echo -n -e "\n"
    echo "In a case when you use keychain to store ssh private key pass phrase, please set the statements below on your shell init script."
    echo "When you use keychain, you need also public keys corresponded to private keys."
    echo -n -e "\n"
    echo "[statements start]"
    echo "export SSH_KEYS_LIST_FILE_PATH=<ssh_private_key_list_file_path>"
    echo ". ${DST_FILE_PATH}"
    echo "[statements end]"
fi

exit 0
