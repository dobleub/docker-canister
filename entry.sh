#!/bin/bash

if [ -f nohup.out ]; then
  exit 0
else
  # Add cargo to the PATH
  echo 'source $HOME/.cargo/env' >> ~/.bashrc
  # Add DFX to the PATH
  echo 'export PATH=$HOME/.local/share/dfx/bin:$PATH' >> ~/.bashrc
  source ~/.bashrc
  # Start the IC
  dfx --version
  dfx start --background

  # Wait for the IC to start,
  # when the IC is ready, deploy the canisters
  until pids=$(pidof dfx)
  do   
    sleep 1
  done

  # Deploy the ledger canister
  source /app/deploy-local-ledger.sh
  # Deploy the internet identity
  dfx deploy internet_identity
  # Deploy the event manager for the frontend and backend
  dfx deploy event_manager_js_backend
  dfx generate event_manager_js_backend
  dfx deploy event_manager_js_frontend
  # Test urls
  python3 /app/canister_urls.py

  # Set the service port forwading
  # source /app/service.sh
  tail -f /dev/null
fi
