#!/bin/bash

check_if_function_exists()
{
    function_name=$1
    result=`aws lambda list-functions`
    function_information=$( { echo ${result} | jq -r ".Functions[] | select(.FunctionName == \"${function_name}\")" ; } 2>&1 )
    function_arn=$( echo ${function_information} | jq -r .FunctionArn )
    echo "${function_arn}"
}

create_function()
{
    function_name=$1
    function_runtime=$2
    function_zip_file=$3
    function_handler=$4
    function_role=$5
    result=$( { aws lambda create-function --function-name ${function_name} --runtime ${function_runtime} --zip-file ${function_zip_file} --handler ${function_handler} --role ${function_role} ; } 2>&1 )
    function_arn=$( echo ${result} | jq -r .FunctionArn )
    echo "${function_arn}"
}

update_function_code()
{
    function_name=$1
    function_zip_file=$2
    result=$( { aws lambda update-function-code --function-name ${function_name} --zip-file ${function_zip_file} ; } 2>&1 )
    echo "${result}"
}

delete_function()
{
    function_name=$1
    result=$( { aws lambda delete-function --function-name ${function_name} ; } 2>&1 )
    echo "${result}"
}

add_env_variables_to_function()
{
    function_name=$1
    env_variables_json_values=$2
    env_variables_parameter="Variables=${env_variables_json_values}"
    result=$( { aws lambda update-function-configuration --function-name ${function_name} --environment ${env_variables_parameter} ; } 2>&1 )
    revision_id=$( echo ${result} | jq -r .RevisionId )
    echo ${revision_id}
}

test_create_function()
{
    function_zip_file="fileb:///Users/raul.devilla/data/TECHANDSOLVE/projects/TechAndSolve/58_tech_assesment/rxsurvey-proxy-api/build/out/package/package-lambda.zip "
    create_function "rxsurvey-proxy" "nodejs12.x" "${function_zip_file}" "index.handler" "arn:aws:iam::475859877097:role/rxsurvey-lambda-role"
}

test_check_if_function_exists()
{
    result=$( check_if_function_exists "rxsurvey-proxy" )
    if [ "${result}" == "" ]; then
        echo "Function don NOT exists"
    else
        echo "Function exists"
    fi
}

test_update_function_code()
{
    update_function_code "rxsurvey-proxy" "fileb:///Users/raul.devilla/data/TECHANDSOLVE/projects/TechAndSolve/58_tech_assesment/rxsurvey-proxy-api/build/out/package/package-lambda.zip"
}

test_delete_function()
{
    delete_function "rxsurvey-proxy"
}

test_add_env_variables_to_function()
{
    result=$( add_env_variables_to_function "rxsurvey-proxy" "{stage=DEV}" )
    echo ${result}
}

#TEST
#test_create_function
#test_check_if_function_exists
#test_update_function_code
#test_delete_function
#test_add_env_variables_to_function
