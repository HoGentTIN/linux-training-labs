# practice: DHCP server with ISC Kea

Practice setup for ISC Kea DHCP server, as described in <https://hogenttin.github.io/linux-training-hogent/opslinux/dhcp_kea/#practice-dhcp-server-with-isc-kea>.

The DHCP server is an AlmaLinux 10 VM with an NAT interface (IP address 10.0.2.15/24, gateway 10.0.2.2 and DNS server 10.0.2.3) and a host-only interface (IP address 192.168.42.254/24).

The VM is also set up as a NAT router, so it can provide Internet access to hosts that are only attached to the host-only network.

Run `vagrant up kea-el` to start and install the VM. After installation, log in with `vagrant ssh kea-el`. Peruse the DHCP server configuration in `/etc/kea/kea-dhcp4.conf`. 

