#!/bin/bash

if [ -f nohup.out ]; then
  cat nohup.out
  rm nohup.out
else
  exit 0
fi
