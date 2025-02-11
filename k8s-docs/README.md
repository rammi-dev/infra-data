ip link - list modify interface on host
ip addr - see ip assigned to interface
ip addr add ip address on the interface
ip route

ip route add

cat /proc/sys/net/ipv4/ip_forward

this is valid only during session. Once restarted is no longer valid 

Traditional
sudo nano /etc/network/interfaces - here it can be persisted

sudo systemctl restart networking - restart networking service

Default Netplan
sudo nano /etc/netplan/00-installer-config.yaml

sudo netplan apply
---------
NetworkManager - common in desktop ubuntu
-------

ifupdown 