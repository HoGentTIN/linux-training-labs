#! /bin/bash
#
# Provisioning script for Vagrant VM

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
export readonly PROVISIONING_FILES="${PROVISIONING_SCRIPTS}/files/${HOSTNAME}"

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

# Install packages. Add more if you want!
sudo dnf install -y \
  bash-completion \
  mdadm \
  tree \
  vim-enhanced
