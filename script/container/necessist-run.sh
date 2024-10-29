#!/bin/bash
set -e

source ~/.bashrc
foundryup --commit $(awk '$1~/^[^#]/' foundry.lock)
source ~/.cargo/env
python3 -m venv .venv
source .venv/bin/activate
cargo install necessist
necessist --verbose --framework foundry -- --ffi

date=$(date +"%Y-%m-%d")
aws s3 cp necessist.db s3://necessist-database/aquifi-liquidity-necessist-${date}.db