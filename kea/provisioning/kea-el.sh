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
PROVISIONING_SCRIPTS="/vagrant/provisioning/"
# Location of files to be copied to this server
PROVISIONING_FILES="${PROVISIONING_SCRIPTS}/${HOSTNAME}"

export PROVISIONING_SCRIPTS PROVISIONING_FILES

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

# Add a user add them to the 'wheel' group
if ! getent passwd "${user}" &> /dev/null; then
  log "Adding user '${user}'"
  useradd "${user}"
  echo "${user}:${user}" | chpasswd
  usermod -aG wheel "${user}"
fi

log "Enabling EPEL repository."
sudo dnf install -y epel-release

log "Installing useful packages."
sudo dnf install -y \
  bash-completion \
  setroubleshoot \
  tcpdump \
  tree \
  vim-enhanced

if ! systemctl is-active setroubleshootd.service; then
  systemctl start setroubleshootd.service
fi

if [ "$(cat /proc/sys/net/ipv4/ip_forward)" != '1' ]; then
  log "Enabling packet forwarding"

  printf 'net.ipv4.ip_forward = 1\n' > /etc/sysctl.d/95-IPv4-forwarding.conf
  sysctl -p /etc/sysctl.d/95-IPv4-forwarding.conf
fi

if ! firewall-cmd --get-active-zones | grep -q external; then
  log "Configuring firewalld for NAT"
  # Avoid SELinux denial due to wrong context on nm config files (usr_tmp_t)
  # Probably an issue with the Vagrant base box?
  restorecon -R /etc/NetworkManager/system-connections/

  firewall-cmd --permanent --zone=external --change-interface=enp0s3 
  firewall-cmd --permanent --zone=internal --change-interface=enp0s8
  firewall-cmd --permanent --zone=internal --add-forward
  firewall-cmd --reload
fi

if ! firewall-cmd --get-policies | grep -q int2ext; then
  log "Creating new firewall policy for forwarding network traffic"
  firewall-cmd --permanent --new-policy=int2ext
  firewall-cmd --permanent --policy=int2ext --set-target=ACCEPT
  firewall-cmd --permanent --policy=int2ext --add-masquerade
  firewall-cmd --permanent --policy=int2ext --add-ingress-zone=internal
  firewall-cmd --permanent --policy=int2ext --add-egress-zone=external
  firewall-cmd --reload
fi

log "Installing and configuring Kea"

dnf install -y kea kea-doc
cp "${PROVISIONING_FILES}/kea-dhcp4.conf" /etc/kea/kea-dhcp4.conf
chmod 640 /etc/kea/kea-dhcp4.conf

if ! systemctl is-enabled kea-dhcp4.service; then
  systemctl enable --now kea-dhcp4.service
fi

log "Installation done. Overview of most important settings:"

log " - IP settings"
ip -br a

log " - Routing table"
ip r

log " - DNS"
cat /etc/resolv.conf

log " - Kea DHCP4 status"

systemctl status kea-dhcp4

