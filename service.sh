#!/bin/bash

# Set the service port forwading from *:4944 to 127.0.0.1:4943
socat TCP4-LISTEN:4944,fork TCP4:127.0.0.1:4943
