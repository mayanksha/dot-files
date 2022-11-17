#!/bin/bash

set -e

##################################################
#
# Author: Mayank Sharma
# Dependencies:
#       * Bitwarden CLI -- bw (node app)
#       * CiscoAnyconnect
#       * expect/autoexpect
#       * openssl
#       * sudo
#
##################################################

SCRIPT_DIR=`dirname "$0"`
KEY_DIR="/var/root/.ssh/other-keys"
ENCRYPTED_MASTER_PASS_FILE="${SCRIPT_DIR}/master-pass.enc"
BW_MASTER_PASS=""

function command_exists () {
    type "$1" &> /dev/null ;
}

function read_and_encrypt_password() {
    echo
    echo "Now setting up Bitwarden's master pass in an encrypted file at ${ENCRYPTED_MASTER_PASS_FILE}"

    if [ -f "${ENCRYPTED_MASTER_PASS_FILE}" ]; then
        echo
        echo "File ${ENCRYPTED_MASTER_PASS_FILE} already exists. If you want to re-create encrypted master pass file, please remove this file, and run this script again. EXITING."
        sudo -k;
        exit 1;
    fi;

    # Read the Bitwarden Master Password
    read -s -p "Bitwarden Master Password: " password
    echo

    echo "Generating encrypted Bitwarden Master Password at ${ENCRYPTED_MASTER_PASS_FILE}"
    echo "${password}" | sudo openssl rsautl -encrypt -pubin -inkey "${KEY_DIR}/pub.pem" \
        > "${ENCRYPTED_MASTER_PASS_FILE}"

    if [ $? -ne 0 ]; then
        echo "Failed while encrypting Master-pass file at ${ENCRYPTED_MASTER_PASS_FILE}. EXITING.";
        rm -f "${ENCRYPTED_MASTER_PASS_FILE}";
        sudo -k;
        exit 1;
    else
        echo "Successfully encrypted specified Bitwarden Master Password at ${ENCRYPTED_MASTER_PASS_FILE}"
        echo
    fi;
}

function decrypt_master_pass() {
    if [ ! -f "${ENCRYPTED_MASTER_PASS_FILE}" ]; then
        echo "${ENCRYPTED_MASTER_PASS_FILE} doesnt't exist..."
        read_and_encrypt_password
    elif [ ! -s "${ENCRYPTED_MASTER_PASS_FILE}" ]; then
        echo "The encrypted master pass file at ${ENCRYPTED_MASTER_PASS_FILE} is empty (0 byte)."
        echo
        echo "Please remove the encrypted master pass file manually and try again. EXITING"
        sudo -k
        exit 1
    else
        echo "${ENCRYPTED_MASTER_PASS_FILE} file found. Decrypting it now...."
    fi;

    BW_MASTER_PASS=`sudo openssl rsautl -decrypt -inkey "${KEY_DIR}/key.pem" -in "${ENCRYPTED_MASTER_PASS_FILE}"`
    if [ $? -ne 0 ]; then
        echo "Failed while decryting Master-pass file at ${ENCRYPTED_MASTER_PASS_FILE}. EXITING.";
        unset "${BW_MASTER_PASS}"
        sudo -k;
        exit 1;
    else
        echo "Successfully decrypted Bitwarden Master Password at ${ENCRYPTED_MASTER_PASS_FILE}"
    fi;
}

function check_first_time_setup_needed() {
    if sudo [ -d "${KEY_DIR}" ] && sudo [ ! -L "${KEY_DIR}" ]; then
        echo "Encryption/Decryption key directory exists. No public-private key pair needs to be created."
        return;
    else
        echo "Setting up public-private key pair for encryption."
    fi;

    # Need to do the setup
    sudo mkdir -p "${KEY_DIR}"
    if [ $? -ne 0 ]; then
        echo "Failure creating Encryption/Decryption key directory at ${KEY_DIR}. EXITING";
        sudo -k;
        exit 1;
    fi;

    if sudo [ ! -d "${KEY_DIR}" ] || sudo [ -L "${KEY_DIR}" ] ; then
        echo "Encryption/Decryption key directory already exists. FAILURE.";
        sudo -k;
        exit 1;
    fi;

    # Create 2048 bit RSA private key in PEM format
    sudo openssl genrsa -out "${KEY_DIR}/key.pem" 2048;
    if [ $? -ne 0 ]; then
        echo "Failure creating Encryption/Decryption PEM keys in ${KEY_DIR}. EXITING";
        sudo -k;
        exit 1;
    fi

    # Make the private key readable by only the root user
    sudo chmod 600 "${KEY_DIR}/key.pem";

    # Generate the corresponding public key which will be used for encryption
    sudo openssl rsa -in "${KEY_DIR}/key.pem" -pubout -out "${KEY_DIR}/pub.pem"
    if [ $? -ne 0 ]; then
        echo "Failure generating RSA public key in ${KEY_DIR}. EXITING";
        sudo -k;
        exit 1;
    fi

    # Make the public key readable by all
    sudo chmod 644 "${KEY_DIR}/pub.pem";

    echo "Done setting up the public-private key pair for encryption/decryption"
    echo

    read_and_encrypt_password

    # Reset the sudo authorization
}

if ! command_exists openssl; then
    echo "Command 'openssl' not found. EXITING."
    exit -1
fi

if ! command_exists sudo; then
    echo "Command 'sudo' not found. EXITING."
    exit -1
fi

if ! command_exists expect; then
    echo "Command 'expect' not found. EXITING."
    exit -1
fi

if ! command_exists bw; then
    echo "Command 'bw' not found. EXITING."
    exit -1
fi

if ! command_exists security; then
    echo "Command 'security' not found. EXITING."
    exit -1
fi

# Clear existing sudo permissions and start from fresh
sudo -k

# Function to setup the public-private RSA keys for the first time, along with saving the
# Bitwarden Master Password in an encrypted form
check_first_time_setup_needed

# Once the setup is done (if it was needed), check if the encrypted master pass file exists and
# decrypt it using root user's private key (the one we generated in above function)
decrypt_master_pass

# Reset sudo privileges
sudo -k

BW_SESSION_KEY=`echo "${BW_MASTER_PASS}" | bw unlock --raw`

PASSWORD=`bw get password "walmart-sso-password" --session ${BW_SESSION_KEY}`
TOTP=`oathtool -b --totp $(bw get password "walmart-totp-key" --session ${BW_SESSION_KEY})`

expect "${SCRIPT_DIR}/script.exp" "${LOGNAME}" "${PASSWORD}" "${TOTP}"
