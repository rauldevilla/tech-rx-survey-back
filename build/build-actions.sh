#!/bin/bash

STAGE=$1
if [ "${STAGE}" == "" ]; then
    STAGE="DEV"
fi

source setup.sh ${STAGE}
source cmd-lambda.sh ${STAGE}
source cmd-iam.sh ${STAGE}
source package.sh ${STAGE}

ACTIVE=true

STAGE=$1
if [ "${STAGE}" == "" ]; then
    STAGE="DEV"
fi

package_and_create_function()
{
    clear_lambda_function_package
    create_lambda_function_package
    create_proxy_function
}

create_iam_structure() 
{
    result=$( check_if_lambda_role_exists )

    if [ "${result}" == "1" ]; then
        info_message "Role ${LAMDA_ROLE_NAME} ALREADY exists"
    else
        warn_message "Role ${LAMDA_ROLE_NAME} does NOT exists"
        create_lambda_execution_role
        attach_execution_policy_to_lambda_role
    fi

    result=$( check_if_dynamodb_policy_exists )
    if [ "${result}" == "1" ]; then
        info_message "Policy ${DYNAMODB_POLICY_NAME} ALREADY exists"
    else
        create_dynamodb_policy
        attach_dynamodb_policy_to_lambda_role
    fi
}

delete_iam_structure()
{
    {
        result=$( dettach_policy_from_role "${LAMDA_ROLE_NAME}" "${LAMBDA_ROLE_POLICY_ARN}" )
        info_message "Policy \"${LAMBDA_ROLE_POLICY_ARN}\" deteched from rol \"${LAMDA_ROLE_NAME}\"."
    }  || {
        error_message "Error detaching policy \"${LAMBDA_ROLE_POLICY_ARN}\" deteched from rol \"${LAMDA_ROLE_NAME}\". ${result}"
    }

    {
        result=$( dettach_policy_from_role "${LAMDA_ROLE_NAME}" "${DYNAMODB_POLICY_ARN}" )
        info_message "Policy \"${DYNAMODB_POLICY_ARN}\" deteched from rol \"${LAMDA_ROLE_NAME}\"."
    }  || {
        error_message "Error detaching policy \"${DYNAMODB_POLICY_ARN}\" deteched from rol \"${LAMDA_ROLE_NAME}\". ${result}"
    }

    {
        result=$( delete_policy "${DYNAMODB_POLICY_ARN}" )
        info_message "Policy \"${DYNAMODB_POLICY_ARN}\" deleted"
    } || {
        error_message "Error deleting polici \"${DYNAMODB_POLICY_ARN}\". ${result}"
    }

    {
        result=$( delete_role "${LAMDA_ROLE_NAME}" )
        info_message "Role \"${LAMDA_ROLE_NAME}\" Deleted."
    } || {
        error_message "Error deleting role \"${LAMDA_ROLE_NAME}\". ${result}"
    }
}

show_head()
{
    echo ""
    echo ""
    echo "******************************************************"
    echo "*                                                    *"
    echo "*                     BUILD TOOLS                    *"
    echo "*                                                    *"
    echo "******************************************************"
    echo ""
}

show_options()
{
    echo ""
    echo "-------------------------------"
    echo "${APP_NAME} MENU OPTIONS"
    echo "-------------------------------"
    echo ""
    echo " 1. Update function"
    echo " 2. Create IAM structure"
    echo " 3. Create function"
    echo " 4. Delete IAM structure"
    echo " 5. Delete function"
    echo "10. Show config"
    echo "99. Exit"
    echo ""
}

read_option()
{
    local choice
    read -p "Enter option: " choice
    case ${choice} in
         1) echo "" & update_proxy_function ;;
         2) echo "" & create_iam_structure ;;
         3) echo "" & package_and_create_function ;;
         4) echo "" & delete_iam_structure ;;
         5) echo "" & delete_proxy_function ;;
        10) echo "" & show_config ;;
        99) clear; ACTIVE=false ;;
        *) echo -e "${RED} Ivalid input${STD}" & sleep 1
    esac
}

main() 
{
    clear & sleep 1
    show_head
    init

    #trap '' SIGINT SIGQUIT SIGTSTP

    while ${ACTIVE}
    do
        show_options
        read_option
    done
}

main