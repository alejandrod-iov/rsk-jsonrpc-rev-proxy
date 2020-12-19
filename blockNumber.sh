#!/bin/bash

#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

RED='\033[0;31m'
WHITE='\033[1;36m'
NC='\033[0m' # No Color

if [ "$*" == "" ]; then
        echo "++++++++                                     ++++++++"
        echo "No arguments provided, setting localhost as default.."
        getBlockNumber="$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber", "params": {},  "id":666}' http://127.0.0.1:4444 |jq -r .result)"
        getDecimal="$(echo $((getBlockNumber)))"
        getCoinbase="$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_coinbase", "params": {},  "id":666}' http://127.0.0.1:4444 |jq -r .result)"
        getSync="$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_syncing", "params": {},  "id":666}' http://127.0.0.1:4444 |jq -r .result)"
        getClientVersion="$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"web3_clientVersion", "params": {},  "id":666}' http://127.0.0.1:4444 |jq -r .result)"
        getPeerList="$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"net_peerList", "params": {},  "id":666}' http://127.0.0.1:4444 |jq -r .result)"
        getPeerCount="$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"net_peerCount", "params": {},  "id":666}' http://127.0.0.1:4444 |jq -r .result)"
                else
                        echo "++++++++                          ++++++++"
                        echo "Querying provided host $1"
                        getBlockNumber="$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber", "params": {},  "id":666}' http://$1:4444 |jq -r .result)"
                        getDecimal="$(echo $((getBlockNumber)))"
                        getCoinbase="$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_coinbase", "params": {},  "id":666}' http://$1:4444 |jq -r .result)"
                        getSync="$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_syncing", "params": {},  "id":666}' http://$1:4444 |jq -r .result)"
                        getClientVersion="$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"web3_clientVersion", "params": {},  "id":666}' http://$1:4444 |jq -r .result)"
                        getPeerList="$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"net_peerList", "params": {},  "id":666}' http://$1:4444 |jq -r .result)"
                        getPeerCount="$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"net_peerCount", "params": {},  "id":666}' http://$1:4444 |jq -r .result)"
                fi


                echo -e "${WHITE}++++              ++++${NC}"
                echo "Server $1 Coinbase:"
                echo -e "${RED}$getCoinbase${NC}"
                echo -e "${WHITE}++++              ++++${NC}"
                echo "Server $1 ClientVersion:"
                echo -e "${RED}$getClientVersion${NC}"
                echo -e "${WHITE}++++              ++++${NC}"
                echo "Server $1 peerList:"
                echo -e "${RED}$getPeerList${NC}"
                echo -e "${WHITE}++++              ++++${NC}"
                echo -e "${RED}$getPeerCount${NC}"
                echo -e "${WHITE}++++              ++++${NC}"
                echo "Current BlockNumber for server $1:"
                echo -e "${RED}$getDecimal${NC}"
                echo -e "${WHITE}++++              ++++${NC}"
                echo "Server $1 isSyncing:"
                echo -e "${RED}$getSync${NC}"
                echo -e "${WHITE}++++              ++++${NC}"
