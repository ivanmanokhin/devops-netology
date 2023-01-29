#!/usr/bin/env bash

set -e

array=(ubuntu centos7 fedora)

for item in ${array[*]}
do
    if [[ "$item" == "centos7" ]]; then
        docker run -dt --name $item centos:$item
    else
        docker run -dt --name $item $item:latest
        if [[ "$item" == "ubuntu" ]]; then
            docker exec ubuntu /bin/bash -c 'apt update && apt install python3 -y'
        fi
    fi
done

ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml --vault-password-file ./secret.file

for item in ${array[*]}
do
    docker stop $item
    docker container rm $item
done
