#!/bin/bash

check_if_role_exists()
{
    role_name=$1
    {
        out_message=`aws iam get-role --role-name ${role_name} 2>&1` &&
        exit_status=1
    } || {
        exit_status=0
    }
    echo ${exit_status}
}

check_if_policy_exists()
{
    policy_arn=$1
    {
        out_message=`aws iam get-policy --policy-arn ${policy_arn} 2>&1` &&
        exit_status=1
    } || {
        exit_status=0
    }
    echo ${exit_status}
}

create_role()
{
    role_name=$1
    policy_file=$2
    {
        out_message=$( { aws iam create-role --role-name ${role_name} --assume-role-policy-document ${policy_file}; } 2>&1 )
        info_message "Role ${role_name} created.  ${out_message}"
    } || {
        error_message "Error creating role ${role_name}.  ${out_message}"
    }
}

create_policy()
{
    policy_name=$1
    policy_file=$2
    out_message=$( { aws iam create-policy --policy-name ${policy_name} --policy-document ${policy_file} ; } 2>&1 )
    echo "${out_message}"
}

delete_policy()
{
    policy_arn=$1
    out_message=$( { aws iam delete-policy --policy-arn ${policy_arn} ; } 2>&1 )
    echo "${out_message}"
}

attach_policy_to_role_policy()
{
    role_name=$1
    policy_arn=$2
    out_message=$( { aws iam attach-role-policy --role-name ${role_name} --policy-arn ${policy_arn}; } 2>&1 )
    echo "${out_message}"
}

delete_role()
{
    role_name=$1
    out_message=$( { aws iam delete-role --role-name ${role_name}; } 2>&1)
    echo "${out_message}"
}

dettach_policy_from_role()
{
    role_name=$1
    policy_arn=$2
    out_message=$( { aws iam detach-role-policy --role-name ${role_name} --policy-arn ${policy_arn}; } 2>&1)
    echo "${out_message}"
}

attach_policy_to_role()
{
    role_name=$1
    policy_arn=$2
    out_message=$( { aws iam attach-role-policy --role-name ${role_name} --policy-arn ${policy_arn}; } 2>&1 )
    echo "${out_message}"
}

get_policy_arn_by_name()
{
    role_name=$1
    result=$( aws iam list-policies )
    policy=$( echo ${result} | jq -r ".Policies[] | select(.PolicyName ==\"${role_name}\" )" )
    policy_arn=$( echo ${policy} | jq -r .Arn )
    echo ${policy_arn}
}

test_get_policy_arn_by_name()
{
    get_policy_arn_by_name "AWSLambdaBasicExecutionRole"
}

#TEST
#test_get_policy_arn_by_name