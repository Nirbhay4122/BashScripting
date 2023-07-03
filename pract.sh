#!/bin/bash

RUN_COMMAND() { $1 | sed "s/^/[$2]  /"; }
RUN_COMMAND "apt-get update" "SYSTEM UPDATE"
RUN_COMMAND "apt-get install curl" "CURL"
INFO='sed "s/^/[INFO]  /"'
