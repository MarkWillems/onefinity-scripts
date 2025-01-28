#!/bin/bash
sed -i "s/NodeDisplayName = \"\"/NodeDisplayName = \"${NODE_NAME//\//\\/}\"/" /opt/onefinity/config/prefs.toml
/opt/onefinity/node --profile-mode --log-save --log-level "*:DEBUG" --log-logger-name --log-correlation --use-health-service --rest-api-interface "localhost:9501" --working-directory "/opt/working-dir/validator" --config-external "/opt/onefinity/config/external_validator.toml" --config "/opt/onefinity/config/config_validator.toml" --validator-key-pem-file "/opt/onefinity/keys/validatorKey.pem"

