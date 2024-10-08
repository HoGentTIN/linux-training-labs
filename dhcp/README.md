# practice: dhcp

Practice setup for ISC DHCP server, as described in <https://hogenttin.github.io/linux-training-hogent/opslinux/dhcp/#practice-dhcp>.

The DHCP server is a Debian 12 VM with an NAT interface (IP address 10.0.2.15/24, gateway 10.0.2.2 and DNS server 10.0.2.3) and a host-only interface (IP address 192.168.42.254/24).

The VM is also set up as a NAT router, so it can provide Internet access to hosts that are only attached to the host-only network.

Run `vagrant up debian` to start and install the VM. After installation, log in with `vagrant ssh debian`. Peruse the DHCP server configuration in `/etc/dhcp/dhcpd.conf`. The configuration file has an example of a client reservation that is commented out. If you want to adapt it to your own setup, find the MAC address of your client VM, make the necessary changes to the config file and restart the service.

