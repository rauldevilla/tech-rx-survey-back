#!/bin/bash

#COLORS
RED='\033[0;41;30m'
GREEN='\033[0;32m'
STD='\033[0;0;39m'

APP_NAME="RX-SURVEY"
BASE_DIR=`pwd`
OUTPUT_DIR="${BASE_DIR}/out"
PACKAGE_DIR="${OUTPUT_DIR}/package"
LAMBDA_ZIP_FILE="${PACKAGE_DIR}/package-lambda.zip"
BUILD_SCRIPTS_DIR="${BASE_DIR}/../build-scripts"

LAMDA_ROLE_NAME="rxsurvey-lambda-role"
LAMBDA_ROLE_POLICY_ARN="arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

STAGE=$1
if [ "${STAGE}" == "" ]; then
    STAGE="DEV"
fi

get_stage() 
{
    if [ "${STAGE}" == "" ]; then
        echo -e "${RED}STAGE NOT CONFIGURED${STD}"
        exit 1
    fi
    echo ${STAGE}
}

message()
{
    option="$1"
    case "${option}" in
        "error") message_type="ERROR" ;;
        "warn") message_type="WARN" ;;
        "info") message_type="INFO" ;;
        "debug") message_type="DEBUG" ;;
        *) message_type="????" ;;
    esac

    cur_date=`date +"%d-%m-%Y %H:%M:%S"`
    echo "[${message_type}] ${cur_date} - :: $2"
}

debug_message()
{
    message "debug" "$1"
}

info_message()
{
    message "info" "$1"
}

warn_message()
{
    message "warn" "$1"
}

error_message()
{
    message "error" "$1"
}

show_config()
{
    info_message "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
    info_message "APP_NAME: ${APP_NAME}"
    info_message "BASE_DIR: ${BASE_DIR}"
    info_message "OUTPUT_DIR: ${OUTPUT_DIR}"
    info_message "PACKAGE_DIR: ${PACKAGE_DIR}"
    info_message "LAMBDA_ZIP_FILE: ${LAMBDA_ZIP_FILE}"
    info_message "LAMDA_ROLE_NAME: ${LAMDA_ROLE_NAME}"
    info_message "CLOUD_FORMATION_SCRIPTS_DIR: ${CLOUD_FORMATION_SCRIPTS_DIR}"
    info_message "LAMBDA_ROLE_POLICY_ARN: ${LAMBDA_ROLE_POLICY_ARN}"
    info_message "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
    info_message ""
}

init()
{
    if [ -d "${OUTPUT_DIR}" ]; then
        warn_message "Output directory already exists"
    else
        mkdir -p ${OUTPUT_DIR}
    fi

    if [ -d "${PACKAGE_DIR}" ]; then
        warn_message "Package directory already exists"
    else
        mkdir -p ${PACKAGE_DIR}
    fi
}
