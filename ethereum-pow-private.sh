#!/bin/bash

if [ -z "$1" ]
then
    echo "Running your own private version of Ethereum PoW protocol"
    echo "Usage instructions:"
    echo "    ./ethereum-pow-private.sh download linux64 - download Linux 64 version of geth"
    echo "    ./ethereum-pow-private.sh download mac - download Mac OS version of geth"
    echo "    ./ethereum-pow-private.sh init - initialize geth for the private Ethereum PoW network"
    echo "    ./ethereum-pow-private.sh run - run private Ethereum PoW node"
    echo "    ./ethereum-pow-private.sh run ETHERBASE - run private Ethereum PoW node that mines on the ETHERBASE address"
else
	case "$1" in
        download)
            if [ -z "$2" ]
            then
                echo "Provide your operating system as second argument - linux64, mac!"
            else
                case "$2" in
                    linux64)
                        echo "Downloading Go Ethereum client for Linux 64 bit..."
                        sleep 2;
                        wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.15-8be800ff.tar.gz;
                        tar xvzf geth-linux-amd64-1.10.15-8be800ff.tar.gz geth-linux-amd64-1.10.15-8be800ff/geth --strip-components 1;
                        echo "Downloading template genesis file for initializing private Ethereum PoW network..."
                        sleep 2;
                        curl -O https://gitlab.uzh.ch/luca.ambrosini/go-ethereum/-/wikis/uploads/f36cd66fb248d69cdcaf6b5b27685d5b/uzheth.json;
                        ;;
                    mac)
                        echo "Downloading Go Ethereum client for Mac OS..."
                        sleep 2;
                        wget https://gethstore.blob.core.windows.net/builds/geth-darwin-amd64-1.10.15-8be800ff.tar.gz;
                        tar xvzf geth-darwin-amd64-1.10.15-8be800ff.tar.gz --strip-components 1;
                        echo "Downloading template genesis file for initializing private Ethereum PoW network..."
                        sleep 2;
                        curl -O https://gitlab.uzh.ch/luca.ambrosini/go-ethereum/-/wikis/uploads/f36cd66fb248d69cdcaf6b5b27685d5b/uzheth.json;
                        ;;
                esac
                echo "Downloading static node file for the private Ethereum PoW network..."
                sleep 2;
                wget https://gitlab.ifi.uzh.ch/-/snippets/28/raw/main/static-nodes.json;
            fi
			;;
		init)
            echo "Initializing private Ethereum PoW node..."
            sleep 2;
            ./geth --datadir blockchain init genesis.json;
            cp static-nodes.json blockchain/geth/.;
			;;
        run)
            if [ -z "$2" ]
            then
                echo "Running private Ethereum PoW node...";
                sleep 2;
                ./geth --datadir blockchain --http --http.port 8545 --http.corsdomain "*" --http.vhosts "*" --http.api miner,eth,admin,net,web3 --networkid 20250115 --syncmode "full" --http.addr 0.0.0.0;
            else
                echo "Running private Ethereum PoW node and miner using $2 as an Etherbase argument...";
                sleep 2;
                ./geth --datadir blockchain --http --http.port 8545 --http.corsdomain "*" --http.vhosts "*" --http.api miner,eth,admin,net,web3 --networkid 20250115 --syncmode "full" --http.addr 0.0.0.0 --mine --miner.threads=1 --miner.etherbase="$2";
            fi
			;;
	esac
fi
