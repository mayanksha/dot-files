#!/bin/bash


##################################################
#
# Author: Mayank Sharma
# Dependencies:
#       * Bitwarden CLI -- bw (node app)
#       * CiscoAnyconnect
#       * expect/autoexpect
#       * Macos 10.15+ (Big Sur works too)
#       * sudo
#
##################################################

command_exists () {
    type "$1" &> /dev/null ;
}

if ! command_exists sudo; then
    echo "Command 'sudo' not found"
    exit -1
fi

if ! command_exists expect; then
    echo "Command 'expect' not found"
    exit -1
fi

if ! command_exists bw; then
    echo "Command 'bw' not found"
    exit -1
fi

if ! command_exists security; then
    echo "Command 'security' not found"
    exit -1
fi

# Reset the sudo privileges and force the user to enter the sudo password/auth by Touch-ID
sudo -k
sudo -l > /dev/null

SCRIPT_DIR="$(dirname $0)"
KEYCHAIN_BW_KEY="bw-master-pass"

SESSION_KEY=$(security find-generic-password -a ${LOGNAME} -s ${KEYCHAIN_BW_KEY} -w | bw unlock --raw)

PASSWORD=`bw get password eb70522c-0bfe-464e-ad35-ad090097241b --session ${SESSION_KEY}`
TOTP=`oathtool -b --totp $(bw get password Walmart-totp-key --session ${SESSION_KEY})`

expect "${SCRIPT_DIR}/script.exp" "${PASSWORD}" "${TOTP}"
