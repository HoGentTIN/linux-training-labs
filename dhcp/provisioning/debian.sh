#! /bin/bash
#
# Provisioning script for srv001

#------------------------------------------------------------------------------
# Bash settings
#------------------------------------------------------------------------------

# Enable "Bash strict mode"
set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't mask errors in piped commands

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# Location of provisioning scripts and files
export readonly PROVISIONING_SCRIPTS="/vagrant/provisioning/"
# Location of files to be copied to this server
export readonly PROVISIONING_FILES="${PROVISIONING_SCRIPTS}/${HOSTNAME}"

# The user to create. Password will be the same as the username, so it's best
# to change it
user="student"

#------------------------------------------------------------------------------
# "Imports"
#------------------------------------------------------------------------------

# Utility functions
source ${PROVISIONING_SCRIPTS}/util.sh

#------------------------------------------------------------------------------
# Provision server
#------------------------------------------------------------------------------

log "Starting server specific provisioning tasks on ${HOSTNAME}"

# Add a user add them to the 'sudo' group
if ! getent passwd "${user}" &> /dev/null; then
  log "Adding user '${user}'"
  useradd \
    --create-home \
    --home-dir /home/"${user}" \
    --skel /etc/skel \
    --shell /bin/bash \
    --groups users,sudo \
    "${user}"
  echo "${user}:${user}" | chpasswd
fi

log "Install useful packages"
apt-get update
apt-get install -y \
  bash-completion \
  tcpdump

log "Copy hosts file to avoid DNS lookup timeouts"
cp "${PROVISIONING_FILES}/hosts.debian"  /etc/hosts

log "Enable routing"
sed -i ' s/^#net\.ipv4\.ip_forward.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p

log "Enable NAT"
nft flush ruleset
nft add table nat
nft 'add chain nat postrouting { type nat hook postrouting priority 100 ; }'
nft add rule nat postrouting masquerade

log "Install DHCP server"
apt-get install -y isc-dhcp-server

log "Turn off IPv6 support"
sed -i 's/^INTERFACESv4.*/INTERFACESv4="eth1"/' /etc/default/isc-dhcp-server
sed -i 's/^INTERFACESv6.*/INTERFACESv6=""/'     /etc/default/isc-dhcp-server

log "Copy config file"
cp "${PROVISIONING_FILES}/dhcpd.conf" /etc/dhcp

log "Checking config file syntax"
/sbin/dhcpd -t -cf /etc/dhcp/dhcpd.conf

log "Starting ISC DHCP server"
systemctl start isc-dhcp-server

