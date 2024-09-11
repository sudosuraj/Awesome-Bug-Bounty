#!/bin/bash
OR='\e[38;5;202m'
GR='\e[32m'
NL='\e[0m'
WH='\e[97m'
BL='\e[34m'

echo -e "
${OR} ${NL}
${OR}                 _                                 _ ${NL}
${OR}                | |                               (_)${NL}
${OR} ___  _   _   __| |  ___   ___  _   _  _ __  __ _  _ ${NL}
${WH}/ __|| | | | / _  | / _ \ / __|| | | ||  |__|/ _ || |${NL}
${WH}\__ \| |_| || (_| || (_) |\__ \| |_| || |  | (_| || |${NL}
${GR}|___/ \__ _| \__ _| \___/ |___/ \__ _||_|   \__ _|| |${NL}
${GR}                                                 _/ |${NL}
${GR}                                                |__/ ${NL}
"
echo -e "This script is made by" ${GR}sudosuraj${NL}
echo ""
echo -e ${OR}Go lang installation${NL}
echo  -e  ${GR}Step 1: Downloading Go Package...${NL}
cd /tmp && wget https://go.dev/dl/go1.23.0.linux-amd64.tar.gz

echo  -e  ${GR}Step 2:Setting up go environment... ${NL}
sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
mkdir $HOME/go
mkdir $HOME/go/bin
mkdir $HOME/go/pkg
mkdir $HOME/go/src

echo 'if [ -d "$HOME/go" ]; then
    GOPATH=$HOME/go
    GOROOT=/usr/local/go
    PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi' >> ~/.bashrc
. ~/.bashrc
echo -e ${GR}Step 3: Verify the installation...${NL}
which go
go version

echo ""
echo "Congrats! The installation is completed"
echo ""
echo -e ${OR}Read the full blog about the installation: ${NL}
echo -e ${GR}https://sudosuraj.github.io/posts/Install-Go-in-Kali-Linux-and-Set-the-Environment-Variable-Path/${NL}
