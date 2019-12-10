#!/bin/bash

# The vagrant provisioning script for ingress node

# Install required softwares
export DEBIAN_FRONTEND=noninteractive
apt-get -y --force-yes install ethtool
apt-get -y --force-yes install iperf
apt-get -y --force-yes install iperf3
apt-get -y --force-yes install libpcap-dev

# Install latest tcpdump that support SR
git clone https://github.com/jorisdejosselin/SRv6-net-prog.git
cd tcpdump/
sudo ./configure
sudo make && sudo make install && cd ..

# Enable IPv6 forwarding
sysctl -w net.ipv6.conf.all.forwarding=1

# Configure interfaces
ifconfig eth1 up
ip -6 addr add 1:2::2/64 dev eth1
# sudo /sbin/sysctl -w net.ipv6.conf.all.seg6_enabled=1
# sudo /sbin/sysctl -w net.ipv6.conf.eth1.seg6_enabled=1

ifconfig eth2 up
ip -6 addr add 2:3::2/64 dev eth2

# Configure routing
ip -6 route add 1::/64 via 1:2::1
ip -6 route add 3::/64 via 2:3::3

# Instal srext
git clone https://github.com/netgroup/SRv6-net-prog
cd SRv6-net-prog/srext/
sudo make && sudo make install && depmod -a

exit
