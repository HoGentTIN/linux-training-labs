#! /usr/bin/env bash
#
# Installs a simple LAMP stack

#{{{ Bash settings
# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't hide errors within pipes
set -o pipefail
#}}}
#{{{ Variables
IFS=$'\t\n'   # Split on newlines and tabs (but not on spaces)
debug_output='yes'

#}}}

main() {
  install_packages
  enable_selinux
  start_basic_services
  configure_webserver
}

#{{{ Helper functions

install_packages() {

  log "Installing packages"

  dnf install -y epel-release
  dnf install -y \
    audit \
    bash-completion \
    bind-utils \
    git \
    httpd \
    mod_ssl \
    mysql \
    python3-policycoreutils \
    php \
    php-mysqlnd \
    pciutils \
    psmisc \
    tree \
    vim-enhanced
}

enable_selinux() {
  if [ "$(getenforce)" != 'Enforcing' ]; then
    log "Enabling SELinux"
    # Enable SELinux right now
    setenforce 1
    # Make the change permanent
    sed -i 's/^SELINUX=[a-z]*$/SELINUX=enforcing/' /etc/selinux/config
  fi
}

start_basic_services() {
  log "Starting essential services"

  systemctl enable --now auditd.service
  systemctl enable --now firewalld.service
}

configure_webserver() {
  log "Installing test page"
  cp /vagrant/www/test.php /home/vagrant
  cp /vagrant/www/test.php /var/www/html/
  chcon -t user_home_t /var/www/html/test.php

  log "Setting port number"
  sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
}

# Usage: log [ARG]...
#
# Prints all arguments on the standard error stream
log() {
  printf '\e[0;33m[LOG]  %s\e[0m\n' "${*}"
}

# Usage: debug [ARG]...
#
# Prints all arguments on the standard error stream
debug() {
  if [ "${debug_output}" = 'yes' ]; then
    printf '\e[0;36m[DBG] %s\e[0m\n' "${*}"
  fi
}

# Usage: error [ARG]...
#
# Prints all arguments on the standard error stream
error() {
  printf '\e[0;31m[ERR] %s\e[0m\n' "${*}" 1>&2
}
#}}}

main "${@}"

