#! /bin/bash

echo -n "Enter your Hipchat API key Send Notification : "
read apikeymessage
if [ -z "${apikeymessage}" ]; then
  echo '!!!!!! ERROR :   API key can not be empty. Exiting. Please retry   !!!!!!'
  exit 1
fi
echo -n "Enter your Hipchat API key  Manage Rooms : "
read apikeycreateroom
if [ -z "${apikeycreateroom}" ]; then
  echo '!!!!!! ERROR :   API key can not be empty. Exiting. Please retry   !!!!!!'
  exit 1
fi

echo ======================== Update and upgrade=======================
sudo apt-get update && sudo apt-get upgrade -y

echo ======================== Install dependency =======================
sudo apt-get install golang git mercurial -y
sudo apt-get install build-essential software-properties-common -y
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt-get update
sudo apt-get install gcc-snapshot -y
sudo apt-get update
sudo apt-get install gcc-6 g++-6 -y

echo ======================== Install go =======================
curl -O https://storage.googleapis.com/golang/go1.7.4.linux-amd64.tar.gz && sudo tar -C /usr/local -xzf go1.7.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

echo “======================== Export Variables =======================
cat << ! >> ~/.bashrc
export GOPATH=\$HOME/gopath
export PATH=\$GOPATH:\$GOPATH/bin:\$PATH
!
source ~/.bashrc

echo ======================== Install Drive App =======================
go get -u github.com/odeke-em/drive/cmd/drive

echo ======================== Initialize Drive App =======================
echo "open the link in a browser then Copy and Paste the authorization code:"
drive init

echo ======================== Adding API keys in the script file =======================
sed -i 's/AUTH_TOKEN_NOTIFICATION=/AUTH_TOKEN_NOTIFICATION='$apikeymessage'/g' Code/ScriptCode.sh
sed -i 's/AUTH_TOKEN_CREATEROOM=/AUTH_TOKEN_CREATEROOM='$apikeycreateroom'/g' Code/ScriptCode.sh
