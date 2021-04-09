#!/bin/bash

# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Run from the root dir of fbpcf so the sample paths exist
cd "$SCRIPT_DIR" || exit
mkdir -p sample

docker run --rm \
    -v "$SCRIPT_DIR/lift/calculator/sample_input:/input" \
    -v "$SCRIPT_DIR/sample:/output" \
    --network=host fbpcf:latest \
        calculator \
        --role=1 \
        --input_directory=/input \
        --input_filenames="publisher_0,publisher_1" \
        --output_directory=/output \
        --output_filenames="publisher_0.out,publisher_1.out" \
        --concurrency=1 \
        2>&1 publisher & # Fork to background so "partner" can run below

docker run --rm \
    -v "$SCRIPT_DIR/lift/calculator/sample_input:/input" \
    -v "$SCRIPT_DIR/sample:/output" \
    --network=host fbpcf:latest \
        calculator \
        --role=2 \
        --server_ip=127.0.0.1 \
        --input_directory=/input \
        --input_filenames="partner_4_convs_0,partner_4_convs_1" \
        --output_directory=/output \
        --output_filenames="partner_4_convs_0.out,partner_4_convs_1.out" \
        --concurrency=1
