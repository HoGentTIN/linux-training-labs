#! /bin/bash
# Provisioning script for srv001

# Variables
readonly hostname=$(hostname)
readonly provisioning_files="/vagrant/provisioning/${hostname}"

# Install tools, useful commands
dnf install -y bash-completion bind-utils tcpdump

# Enable and configure the firewall
systemctl enable --now firewalld
firewall-cmd --add-service=dns --permanent
firewall-cmd --reload

# Install and start BIND
dnf install -y bind
systemctl enable --now named.service

# Copy linuxtrn.lan zone file
cp "${provisioning_files}/linuxtrn.lan" /var/named/
named-checkzone linuxtrn.lan /var/named/linuxtrn.lan

# Copy main configuration file
cp "${provisioning_files}/named.conf" /etc/
named-checkconf /etc/named.conf

# Restart BIND after configuration changes
systemctl restart named.service

# Enable query log
rndc querylog on
