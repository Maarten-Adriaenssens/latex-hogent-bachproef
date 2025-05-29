# Script to install Open5GS on Ubuntu 22.04
#Device: Conductur / Centrale
#-----------------------------------------------------------
#Install MongoDB for Open5GS
sudo apt-get install gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
#-----------------------------------------------------------
#Install Open5GS
sudo add-apt-repository ppa:open5gs/latest
sudo apt update
sudo apt install -y open5gs

#-----------------------------------------------------------
# Download and import the Nodesource GPG key
sudo apt update
sudo apt install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
#Run Update and Install
sudo apt update
sudo apt install nodejs -y

#-----------------------------------------------------------
#Install Open5GS WebUI
curl -fsSL https://open5gs.org/open5gs/assets/webui/install | sudo -E bash -

sudo systemctl start open5gs-webui
sudo systemctl enable open5gs-webui

sudo sed -i "s/'localhost'/'10.0.2.15'/" /usr/lib/node_modules/open5gs/server/index.js # Change localhost
sudo systemctl daemon-reload
sudo systemctl restart open5gs-webui.service
sudo systemctl restart open5gs-webui

#-----------------------------------------------------------
#Installation of UERANSIM
git clone https://github.com/aligungr/UERANSIM
sudo apt install -y cmake
sudo apt install -y gcc
sudo apt install -y g++
sudo apt install -y libsctp-dev lksctp-tools
sudo apt install -y iproute2
sudo snap install cmake --classic
cd UERANSIM
make

#-----------------------------------------------------------
#Change IP addresses in Open5GS and UERANSIM configuration files
sudo sed -i '23s/127.0.0.5/10.0.0.10/' /etc/open5gs/amf.yaml # Change AMF IP address
sudo sed -i '20s/127.0.0.7/10.0.0.10/' /etc/open5gs/upf.yaml # Change UPF IP address
sudo systemctl daemon-reload # Reload systemd to recognize changes
sudo systemctl restart open5gs-amfd # Restart AMF service to apply changes
sudo systemctl restart open5gs-upfd # Restart UPF service to apply changes

#-----------------------------------------------------------
#NAT Port Forwarding
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo systemctl stop ufw
sudo iptables -I FORWARD 1 -j ACCEPT