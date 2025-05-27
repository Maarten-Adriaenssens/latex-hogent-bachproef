# Script to install Open5GS and UERANSIM on Ubuntu 22.04
# Device: Member / UE
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
# #Change IP addresses in Open5GS and UERANSIM configuration files
# sudo sed -i '23s/127.0.0.5/10.0.2.15/' /etc/open5gs/amf.yaml # Change AMF IP address
# sudo systemctl restart open5gs-amfd # Restart AMF service to apply changes
# sudo sed -i 's/127.0.0.1/10.0.2.15/' ~/ UERANSIM/config/open5gs-ue.yaml # Change UE IP address
# sudo sed -i 's/127.0.0.1/10.0.2.15/' ~/ UERANSIM/config/open5gs-gnb.yaml # Change gNB IP address
# sudo sed -i 's/127.0.0.5/10.0.2.15/' ~/ UERANSIM/config/open5gs-gnb.yaml # Change gNB AMF IP address