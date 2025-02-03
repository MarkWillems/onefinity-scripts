#!/bin/bash
mxpy validator stake \
  --pem=/in/walletKey.pem \
  --value="2500000000000000000000" \
  --validators-file=/opt/onefinity/validator.json \
  --proxy="https://gateway.validators.onefinity.network" \
  --gas-limit 25000000 \
  --recall-nonce \
  --send

