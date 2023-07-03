#!/bin/bash
if command -v lsb_release >/dev/null 2>&1; then VERSION_ID=$(lsb_release -rs); echo ${VERSION_ID}; else apt update && apt install lsb-release; fi