#!/bin/bash

create_dynamodb_create()
{
    table_name=$1
    attribute_definitions=$2
    key_schema=$3
    provisioned_throughput=$4

    if [ "${key_schema}" != "" ]; then
        key_schema_parameter="key_schema ${key_schema}"
    fi

    if [ "${provisioned_throughput}" != "" ]; then
        provisioned_throughput_parameter="--provisioned-throughput ${provisioned_throughput}"
    else
        provisioned_throughput_parameter="--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1"
    fi

    result=$( {aws dynamodb create-table --table-name ${table_name} --attribute-definitions ${attribute_definitions} ${key_schema_parameter} ${provisioned_throughput_parameter} ; } 2>&1 )
    table_arn=$( echo ${result} | jq -r .TableArn )
    echo ${table_arn}
}
