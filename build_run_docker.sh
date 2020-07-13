#!/bin/bash

# QUANTCONNECT.COM - Democratizing Finance, Empowering Individuals.
# Lean Algorithmic Trading Engine v2.0. Copyright 2014 QuantConnect Corporation.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

full_path=$(realpath $0)
current_dir=$(dirname $full_path)
default_image=lean-build-run:latest
default_data_dir=$current_dir/Data
default_results_dir=$current_dir/Results
default_config_file=$current_dir/Launcher/config.json
default_code_dir=$current_dir

if [ -f "$1" ]; then
    IFS="="
    while read -r key value; do
        eval "$key='$value'"
    done < $1
else
    read -p "Enter docker image [default: $default_image]: " image
    read -p "Enter absolute path to Lean config file [default: $default_config_file]: " config_file
    read -p "Enter absolute path to Data folder [default: $default_data_dir]: " data_dir
    read -p "Enter absolute path to store results [default: $default_results_dir]: " results_dir
    read -p "Enter absolute path to the code folder [default: $default_code_dir]: " code_dir
fi

if [ -z "$image" ]; then
    image=$default_image
fi

if [ -z "$config_file" ]; then
    config_file=$default_config_file
fi

if [ ! -f "$config_file" ]; then
    echo "Lean config file $config_file does not exist"
    exit 1
fi

if [ -z "$data_dir" ]; then
    data_dir=$default_data_dir
fi

if [ ! -d "$data_dir" ]; then
    echo "Data directory $data_dir does not exist"
    exit 1
fi

if [ -z "$results_dir" ]; then
    results_dir=$default_results_dir
fi

if [ ! -d "$results_dir" ]; then
    echo "Results directory $results_dir does not exist"
    exit 1
fi

if [ -z "$code_dir" ]; then
    code_dir=$default_code_dir
fi

if [ ! -d "$code_dir" ]; then
    echo "Code directory $code_dir does not exist"
    exit 1
fi

docker run -it --rm \
 --mount type=bind,source=$code_dir,target=/Lean \
 --mount type=bind,source=$config_file,target=/Lean/Launcher/config.json,readonly \
 --mount type=bind,source=$data_dir,target=/Lean/Data,readonly \
 --mount type=bind,source=$results_dir,target=/Lean/Results \
 $image
