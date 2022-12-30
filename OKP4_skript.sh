#!/bin/bash
RED_COLOR='\033[0;31m'
WITHOU_COLOR='\033[0m'
DELEGATOR_ADDRESS='YOUR_ADDRESS'
VALIDATOR_ADDRESS='YOUR_VOLOPER'
DELAY=60*1 #in secs - how often restart the script 
WALLET_NAME=wallet #example: = WALLET_NAME=wallet_qwwq_54
#NODE="tcp://localhost:26657" #change it only if you use another rpc port of your node

for (( ;; )); do
        echo -e "Get reward from Delegation"
        echo "YOUR_PASSWORD" | okp4d tx distribution withdraw-rewards ${VALIDATOR_ADDRESS} --from ${WALLET_NAME} --chain-id okp4-nemeton-1 --fees 500uknow --commission -y
        for (( timer=30; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
                sleep 1
        done
 
#        BAL=$(okp4d query bank balances ${DELEGATOR_ADDRESS} --chain-id okp4-nemeton-1 | awk '/amount:/{print $NF}' | tr -d '"')
        BAL=$(okp4d query bank balances ${DELEGATOR_ADDRESS} --chain-id okp4-nemeton-1 --output json | jq -r '.balances[] | select(.denom=="uknow")' | jq -r .amount)
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} uknow\n"

       
        BAL=$(okp4d query bank balances ${DELEGATOR_ADDRESS} --chain-id okp4-nemeton-1 --output json | jq -r '.balances[] | select(.denom=="uknow")' | jq -r .amount)
#        BAL=$(okp4d query bank balances ${DELEGATOR_ADDRESS} --chain-id okp4-nemeton-1 | awk '/amount:/{print $NF}' | tr -d '"')
        BAL=$(($BAL-50000))
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} uknow\n"
        echo -e "Stake ALL 11111\n"
        if (( BAL > 900000 )); then
        echo "YOUR_PASSWORD" | okp4d tx staking delegate ${VALIDATOR_ADDRESS} ${BAL}uknow --from ${WALLET_NAME} --chain-id okp4-nemeton-1 --fees 1000uknow --yes
        else
          echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} uknow BAL < 900000 ((((\n"
        fi 
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
                sleep 1
        done       

done
