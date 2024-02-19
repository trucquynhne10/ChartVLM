#!/usr/bin/env bash

set -x
Nnodes=$1
NGPUS=$2
PY_ARGS=${@:3}

while true
do
    PORT=$(( ((RANDOM<<15)|RANDOM) % 49152 + 10000 ))
    status="$(nc -z 127.0.0.1 $PORT < /dev/null &>/dev/null; echo $?)"
    if [ "${status}" != "0" ]; then
        break;
    fi
done
echo $PORT
torchrun --standalone --nnodes=${Nnodes} --nproc_per_node=${NGPUS} --master_port=${PORT} finetune.py  ${PY_ARGS} --world_size ${NGPUS}