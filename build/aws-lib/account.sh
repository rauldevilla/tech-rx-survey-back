#!/bin/bash

get_account_id()
{
    main_organizacion_name=$1
    result=`aws organizations list-accounts`
    organization_information=$( echo ${result} | jq -r ".Accounts[] | select(.Name == \"$main_organizacion_name\")" )
    id=$( echo ${organization_information} | jq -r .Id )
    echo ${id}
}

test_get_account_id()
{
    main_org_name="Tech And Solve"
    myId=$( get_account_id "${main_org_name}" )
    echo "Id: --${myId}--"
}

#TEST
#test_get_account_id