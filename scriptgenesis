#!/bin/bash

while true
do

# Logo

echo -e "\033[0;35m"                                                                                                        
echo "    SSSSSSSSSSSSSSS TTTTTTTTTTTTTTTTTTTTTTT         AAA   VVVVVVVV           VVVVVVVVRRRRRRRRRRRRRRRRR    ";
echo "  SS:::::::::::::::ST:::::::::::::::::::::T        A:::A  V::::::V           V::::::VR::::::::::::::::R   ";
echo " S:::::SSSSSS::::::ST:::::::::::::::::::::T       A:::::A V::::::V           V::::::VR::::::RRRRRR:::::R  ";
echo " S:::::S     SSSSSSST:::::TT:::::::TT:::::T      A:::::::AV::::::V           V::::::VRR:::::R     R:::::R ";
echo " S:::::S            TTTTTT  T:::::T  TTTTTT     A:::::::::AV:::::V           V:::::V   R::::R     R:::::R ";
echo " S:::::S                    T:::::T            A:::::A:::::AV:::::V         V:::::V    R::::R     R:::::R ";
echo "  S::::SSSS                 T:::::T           A:::::A A:::::AV:::::V       V:::::V     R::::RRRRRR:::::R  ";
echo "   SS::::::SSSSS            T:::::T          A:::::A   A:::::AV:::::V     V:::::V      R:::::::::::::RR   ";
echo "     SSS::::::::SS          T:::::T         A:::::A     A:::::AV:::::V   V:::::V       R::::RRRRRR:::::R  ";
echo "       SSSSSS::::S         T:::::T        A:::::AAAAAAAAA:::::AV:::::V V:::::V        R::::R     R:::::R  ";
echo "             S:::::S        T:::::T       A:::::::::::::::::::::AV:::::V:::::V         R::::R     R:::::R ";
echo "             S:::::S        T:::::T      A:::::AAAAAAAAAAAAA:::::AV:::::::::V          R::::R     R:::::R ";
echo " SSSSSSS     S:::::S      TT:::::::TT   A:::::A             A:::::AV:::::::V         RR:::::R     R:::::R ";
echo " S::::::SSSSSS:::::S      T:::::::::T  A:::::A               A:::::AV:::::V          R::::::R     R:::::R ";
echo " S:::::::::::::::SS       T:::::::::T A:::::A                 A:::::AV:::V           R::::::R     R:::::R ";
echo "  SSSSSSSSSSSSSSS         TTTTTTTTTTTAAAAAAA                   AAAAAAAVVV            RRRRRRRR     RRRRRRR ";
                                                                                                        
echo -e "\e[0m"

# Menu

PS3='Select an action: '
options=(
"Install Node"
"Exit")
select opt in "${options[@]}"
do
case $opt in

"Install Node")
echo "****"
echo "Install start"
echo "****"
echo "Setup ValidatorName:"
echo "****"
read ValidatorName
echo "****"
echo export ValidatorName=${NODENAME} >> $HOME/.bash_profile
echo export CHAIN_ID="genesis_29-2" >> $HOME/.bash_profile
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
sudo curl https://get.ignite.com/cli! | sudo bash
git clone https://github.com/alpha-omega-labs/genesisd
cd genesisd
make install

genesisd init $NODENAME --chain-id $CHAIN_ID

wget -O $HOME/.genesisd/config/genesis.json "https://github.com/alpha-omega-labs/genesisd/raw/neolithic/genesis_29-1-state/genesis.json"

peers="551cb3d41d457f830d75c7a5b8d1e00e6e5cbb91@135.181.97.75:26656,5082248889f93095a2fd4edd00f56df1074547ba@146.59.81.204:26651,36111b4156ace8f1cfa5584c3ccf479de4d94936@65.21.34.226:26656,c23b3d58ccae0cf34fc12075c933659ff8cca200@95.217.207.154:26656,37d8aa8a31d66d663586ba7b803afd68c01126c4@65.21.134.70:26656,d7d4ea7a661c40305cab84ac227cdb3814df4e43@139.162.195.228:26656,be81a20b7134552e270774ec861c4998fabc2969@genesisl1.3ventures.io:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.genesisd/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.genesisd/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025el1\"/;" ~/.genesisd/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.genesisd/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.genesisd/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.genesisd/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.genesisd/config/config.toml

wget -O $HOME/.genesisd/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Genesisl1/addrbook.json"


# config pruning & indexer
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.genesisd/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.genesisd/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.genesisd/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.genesisd/config/app.toml
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.genesisd/config/config.toml



sudo tee /etc/systemd/system/genesisd.service > /dev/null <<EOF
[Unit]
Description=genesisd
After=network-online.target

[Service]
User=$USER
ExecStart=$(which genesisd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload && \
sudo systemctl enable genesisd && \
sudo systemctl restart genesisd && \
sudo journalctl -u genesisd -f -o cat


"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
