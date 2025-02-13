# Core infrastrucure shoudl be Vault Minio

## Minio install on separate Virtual Box

### Create virtual machine with ubuntu

### Update system
sudo apt update
sudo apt upgrade -y

### Create a user for MinIO
sudo useradd -r -m -s /bin/bash minio-user

# Download and set up MinIO binary
wget https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio
sudo mv minio /usr/local/bin/

# Create MinIO data directory
sudo mkdir -p /usr/local/share/minio
sudo chown minio-user:minio-user /usr/local/share/minio

# Create MinIO service file
sudo vim /etc/systemd/system/minio.service

'''
[Unit]
Description=MinIO
Documentation=https://docs.min.io
After=network.target

[Service]
User=minio-user
Group=minio-user
ExecStart=/usr/local/bin/minio server /usr/local/share/minio --console-address ":9001"
Restart=always
LimitNOFILE=65536
EnvironmentFile=-/etc/minio/minio.conf

[Install]
WantedBy=multi-user.target

'''

# Reload systemd and enable the service
sudo systemctl daemon-reload
sudo systemctl enable minio

# Start MinIO
sudo systemctl start minio

# Check the status of MinIO
sudo systemctl status minio

## Install Vault


### Install required dependencies (if needed)
sudo apt install -y curl unzip

### Download Vault binary (take latest version)
wget https://releases.hashicorp.com/vault/1.18.4/vault_1.18.4_linux_amd64.zip

### Unzip Vault binary
unzip vault_1.18.4_linux_amd64.zip

### Move Vault binary to /usr/local/bin
sudo mv vault /usr/local/bin/

### Create directories for Vault
sudo mkdir -p /etc/vault.d
sudo mkdir -p /var/lib/vault

### Create a Vault user
sudo useradd -r -m -s /bin/bash vault
sudo chown -R vault:vault /var/lib/vault /etc/vault.d

### Create Vault systemd service file
sudo vim /etc/systemd/system/vault.service

'''
[Unit]
Description=Vault
Documentation=https://www.vaultproject.io/docs/
After=network.target

[Service]
User=vault
Group=vault
ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault.hcl
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target

'''

### Configure Vault settings
IP_ADDRESS=$(hostname -I | awk '{print $1}')


sudo nano /etc/vault.d/vault.hcl

'''

storage "file" {
  path = "/var/lib/vault/data"  # Where Vault stores its data (use a directory with write access)
}

listener "tcp" {
  address = "0.0.0.0:8200"  # Listen on all interfaces and port 8200
  tls_disable = 1             # Disable TLS for now (only for local/testing environments)
}

api_addr = "http://IP_ADDRESS:8200"  # The API address that Vault will use for clients


cluster_addr = "http://IP_ADDRES:8201"  # Vault's cluster communication address (optional for single node)

ui = true  # Enable the Vault web UI

disable_mlock = true

'''

### Reload systemd and enable Vault service
sudo systemctl daemon-reload
sudo systemctl enable vault

### Start Vault service
sudo systemctl start vault

### Verify the Vault service
sudo systemctl status vault

### Initialize Vault
sudo vault operator init

### Unseal Vault
access UI and generate token and key
Token
hvs.stF7q77J --- lmeRdJVsKp4Y0z75

unseal key
Pr8p6VCfIX90ybj ---  4fEpFx1BKm3Nkbw4N6BxKF7HiiW4=
sudo vault operator unseal Pr8p6VCfIX90ybj4fEpFx1BKm3Nkbw4N6BxKF7HiiW4=

###
Access Vault UI (http://192.168.1.28:8200)






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


nslookup - resolve IP for in DNS but not locally
dig - dbs test resolution

-----------------------------
coreDNS

.:1053 {
  forward . 8.8.8.8
}

Coredns to work on 1053 not 53s