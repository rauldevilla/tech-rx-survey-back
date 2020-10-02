#!/bin/bash

create_dynamodb_create()
{
    table_name=$1
    attribute_definitions=$2
    key_schema=$3
    provisioned_throughput=$4

    if [ "${key_schema}" != "" ]; then
        key_schema_parameter="--key-schema ${key_schema}"
    fi

    if [ "${provisioned_throughput}" == "" ]; then
        provisioned_throughput="ReadCapacityUnits=1,WriteCapacityUnits=1"
    fi

    
    result=$( { aws dynamodb create-table --table-name ${table_name} --attribute-definitions ${attribute_definitions} --key-schema ${key_schema} --provisioned-throughput ${provisioned_throughput} ; } 2>&1 )
    table_arn=$( echo ${result} | jq -r .TableDescription.TableArn )
    echo ${table_arn}
}

delete_dynamodb_table()
{
    table_name=$1
    result=$( { aws dynamodb delete-table --table-name ${table_name} ; } 2>&1 )
    status=$( echo ${result} | jq -r .TableDescription.TableStatus )
    echo ${status}
}

check_if_table_exists()
{
    table_name=$1
    result=$( { aws dynamodb list-tables  ; } 2>&1 )
    tables=$( echo ${result} | jq -r "select(.TableNames | index(\"${table_name}\"))" )

    if [ "${tables}" != "" ]; then
        echo ${table_name}
    else
        echo ""
    fi
}


test_check_if_table_exists()
{
    table_name="rxsurvey-survey"
    result=$( check_if_table_exists "${table_name}" )
    if [ "${result}" != "" ]; then
        echo "Table \"${table_name}\" exists"
    else
        echo "Table \"${table_name}\" NOT exists"
    fi
}

test_create_dynamodb_create()
{
    table_name="rxsurvey-DEV-survey"
    table_attributs_definition="AttributeName=SurveyId,AttributeType=S"
    key_schema="AttributeName=SurveyId,KeyType=HASH"
    create_dynamodb_create ${table_name} ${table_attributs_definition} ${key_schema}
}

test_delete_dynamodb_table()
{
    table_name="rxsurvey-DEV-survey"
    delete_dynamodb_table ${table_name}
}

#TEST
#test_check_if_table_exists
#test_create_dynamodb_create
#test_delete_dynamodb_table