#! /bin/bash

echo ======================== Update and upgrade =======================
sudo apt-get update && sudo apt-get upgrade -y

echo ======================== Install dependency =======================
sudo apt-get install golang git mercurial -y
#sudo apt-get install build-essential software-properties-common -y
#sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
#sudo apt-get update
#sudo apt-get install gcc-snapshot -y
#sudo apt-get update
#sudo apt-get install gcc-6 g++-6 -y

echo ======================== Install go =======================
curl -O https://storage.googleapis.com/golang/go1.7.4.linux-amd64.tar.gz && sudo tar -C /usr/local -xzf go1.7.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

echo ======================== Export Variables =======================
export GOPATH=\$HOME/gopath
export PATH=\$GOPATH:\$GOPATH/bin:\$PATH
cat << ! >> ~/.bashrc
export GOPATH=\$HOME/gopath
export PATH=\$GOPATH:\$GOPATH/bin:\$PATH
!
source ~/.bashrc

echo ======================== Install Drive App =======================
go get -u github.com/odeke-em/drive/cmd/drive
