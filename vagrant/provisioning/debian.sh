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

log "Add entry to hosts file to avoid DNS lookup timeouts"
cat > /etc/hosts << _EOF_
127.0.0.1	localhost  localhost.localdomain
127.0.1.1	debian	   debian.localdomain

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
_EOF_

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

# Install packages. Add more if you want!
apt-get update
apt-get install -y \
  bash-completion \
  tcpdump

