#! /usr/bin/env bash
#
# Installs and configures MariaDB

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
debug_output='no'

mariadb_root_password='7OdFobyak}0vedutNat+'
wordpress_database='wordpress'
wordpress_user='wordpress_user'
wordpress_password='Amt_OtMat7'

demo_database='demo'
demo_user='demo_user'
demo_password='ArfovWap_OwkUfeaf4'
#}}}

main() {
  # Ensure vagrant can read logs without sudo
  usermod --append --groups adm vagrant

  install_packages
  enable_selinux
  start_basic_services

  setup_mariadb
  ensure_db_exists "${wordpress_database}" "${wordpress_user}" "${wordpress_password}"
  initialize_demo_db
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
    mariadb \
    mariadb-server \
    mod_ssl \
    pciutils \
    psmisc \
    python3-policycoreutils \
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
  systemctl start auditd.service
  systemctl restart NetworkManager.service
  systemctl enable --now firewalld.service
}

setup_mariadb() {
  log "Starting MariaDB"
  systemctl start mariadb.service
  systemctl enable mariadb.service
  firewall-cmd --add-service=mysql
  firewall-cmd --add-service=mysql --permanent

  log "Set MariaDB root password"

  if mysqladmin -u root status > /dev/null 2>&1; then
    # if the previous command succeeds, the root password was not set
    mysqladmin password "${mariadb_root_password}" > /dev/null 2>&1
    log "ok"
  else
    log "password already set."
  fi

  log "Securing database installation"

  mysql --user=root --password="${mariadb_root_password}" mysql << _EOF_
DELETE FROM user WHERE user='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
_EOF_

}

ensure_db_exists() {
  local db_name="${1}"
  local db_user="${2}"
  local db_password="${3}"

  log "Creating database ${db_name} and user ${db_user}"

  mysql --user=root --password="${mariadb_root_password}" mysql << _EOF_
CREATE DATABASE IF NOT EXISTS ${db_name};
GRANT ALL ON ${db_name}.* TO '${db_user}'@'%' identified by '${db_password}';
FLUSH PRIVILEGES;
_EOF_
}

initialize_demo_db() {
  ensure_db_exists "${demo_database}" "${demo_user}" "${demo_password}"

  log "Inserting data into database ${demo_database}"

  table="${demo_database}_tbl"

  mysql --user="${demo_user}" --password="${demo_password}" "${demo_database}" << _EOF_
DROP TABLE IF EXISTS ${table};
CREATE TABLE ${table} (
  id int(5) NOT NULL AUTO_INCREMENT,
  name varchar(50) DEFAULT NULL,
  PRIMARY KEY(id)
);
INSERT INTO ${table} (name) VALUES ("Tuxedo T. Penguin");
INSERT INTO ${table} (name) VALUES ("Bobby Tables");
_EOF_

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

