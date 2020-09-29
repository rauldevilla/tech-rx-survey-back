#!/bin/bash

source setup.sh
source cmd-lambda.sh
source package.sh

ACTIVE=true

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

package_and_create_function()
{
    clear_lambda_function_package
    create_lambda_function_package
    create_proxy_function
}

read_option()
{
    local choice
    read -p "Enter option: " choice
    case ${choice} in
         1) echo "" & update_proxy_function ;;
         3) echo "" & package_and_create_function ;;
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