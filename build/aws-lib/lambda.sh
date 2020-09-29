#!/bin/bash

check_if_function_exists()
{
    function_name=$1
    {
        result=`aws lambda get-function --function-name ${function_name} 2>&1` &&
        exit_status=1
    } || {
        exit_status=0
    }
    echo ${exit_status1}
}

create_function()
{
    function_name=$1
    function_runtime=$2
    function_zip_file=$3
    function_handler=$4
    function_role=$5
    result=$( { aws lambda create-function --function-name ${function_name} --runtime ${function_runtime} --zip-file ${function_zip_file} --handler ${function_handler} --role ${function_role} ; } 2>&1 )
    echo "${result}"
}

update_function_code()
{
    function_name=$1
    function_zip_file=$2
    result=$( { aws lambda update-function-code --function-name ${function_name} --zip-file ${function_zip_file} ; } 2>&1 )
    echo "${result}"
}

test_create_function()
{
    function_zip_file="fileb:///Users/raul.devilla/data/TECHANDSOLVE/projects/TechAndSolve/58_tech_assesment/rxsurvey-proxy-api/build/out/package/package-lambda.zip "
    create_function "rxsurvey-proxy" "nodejs12.x" "${function_zip_file}" "index.handler" "arn:aws:iam::475859877097:role/rxsurvey-lambda-role"
}

test_check_if_function_exists()
{
    result=$( check_if_function_exists "rxsurvey-proxy" )
    if [ "${result}" == "1" ]; then
        echo "Function exists"
    else
        echo "Function NOT exists"
    fi
}

test_update_function_code()
{
    update_function_code "rxsurvey-proxy" "fileb:///Users/raul.devilla/data/TECHANDSOLVE/projects/TechAndSolve/58_tech_assesment/rxsurvey-proxy-api/build/out/package/package-lambda.zip"
}

#TEST
#test_create_function
#test_check_if_function_exists
test_update_function_code

