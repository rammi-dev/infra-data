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

# DNS
ORder in which names are resolved 
cat /etc/nsswitch.conf

hosts:          files dns
-----------------------------

/etc/resolv.conv - configure nameserver 8.8.8.8 - google dns eg.
                             search - appends to each request 

Records type
A example.com.  IN  A  192.0.2.1    -> IPv4
AAAA  example.com.  IN  AAAA  2606:2800:220:1:248:1893:25c8:1946  -> IPv6 address
CNAME www.example.com.  IN  CNAME  example.com.      -> aliases