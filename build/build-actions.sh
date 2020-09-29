#!/bin/bash

source setup.sh
source cmd-lambda.sh

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
    echo "99. EXIT"
    echo ""
}

read_option()
{
    local choice
    read -p "Enter option [ 1 - 5 ]: " choice
    case ${choice} in
         1) echo "" & update_proxy_function ;;
        10) echo "" & show_config ;;
        99) clear; ACTIVE=false ;;
        *) echo -e "${RED} Ivalid input${STD}" & sleep 1
    esac
}

main() 
{
    clear & sleep 2
    show_head

    #trap '' SIGINT SIGQUIT SIGTSTP

    while ${ACTIVE}
    do
        show_options
        read_option
    done
}

main