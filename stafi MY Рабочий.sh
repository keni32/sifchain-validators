#!/bin/bash

while true
do

# Logo

curl -s https://raw.githubusercontent.com/obajay/nodes-Guides/main/logo_1 | bash

# Menu

PS3='Select an action: '
options=(
"Install Node"
"Exit")
select opt in "${options[@]}"
do
case $opt in

"Install Node")
echo "*********************"
echo "Lets's begin"
echo "*********************"
echo "Your Validator_Name:"
echo "_|-_|-_|-_|-_|-_|-_|"
read NODENAME
echo "_|-_|-_|-_|-_|-_|-_|"
echo export NODENAME=${NODENAME} >> $HOME/.bash_profile
echo export CHAIN_ID="stafihub-testnet-1" >> $HOME/.bash_profile
source ~/.bash_profile

#UPDATE APT
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y

#INSTALL GO
ver="1.18.3" && \
cd $HOME && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version

#INSTALL
cd $HOME
git clone --branch public-testnet https://github.com/stafihub/stafihub
cd $HOME/stafihub
make install

stafihubd init $NODENAME --chain-id $CHAIN_ID


wget -O $HOME/.stafihub/config/genesis.json "https://raw.githubusercontent.com/tore19/network/main/testnets/stafihub-testnet-1/genesis.json"

seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.stafihub/config/config.toml
peers="4e2441c0a4663141bb6b2d0ea4bc3284171994b6@46.38.241.169:26656,79ffbd983ab6d47c270444f517edd37049ae4937@23.88.114.52:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.stafihub/config/config.toml


# pruning and indexer
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.stafihub/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.stafihub/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.stafihub/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.stafihub/config/app.toml
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.stafihub/config/config.toml


sudo tee /etc/systemd/system/stafihubd.service > /dev/null <<EOF
[Unit]
Description=stafihubd
After=network-online.target

[Service]
User=$USER
ExecStart=$(which stafihubd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable stafihubd
sudo systemctl restart stafihubd
sudo journalctl -u stafihubd -f -o cat

break
;;

"Exit")
exit
;;
esac
done
done
