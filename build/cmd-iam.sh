#!/bin/bash

source setup.sh
source aws-lib/iam.sh
source aws-lib/account.sh

AWS_ACCOUNT_ID=$( get_account_id "Tech And Solve" )
info_message "AWS_ACCOUNT_ID: ${AWS_ACCOUNT_ID}"

LAMBDA_ROLE_TRUST_POLICY_FILE="file://${BUILD_SCRIPTS_DIR}/lambda-policy.json"
DYNAMODB_POLICY_FILE="file://${BUILD_SCRIPTS_DIR}/dynamodb-policy.json"
DYNAMODB_POLICY_NAME="rxsurvey-dynamodb-policy"
DYNAMODB_POLICY_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${DYNAMODB_POLICY_NAME}"


check_if_lambda_role_exists()
{
    result=$( check_if_role_exists "${LAMDA_ROLE_NAME}" )
    echo ${result}
}

check_if_dynamodb_policy_exists()
{
    result=$( check_if_policy_exists "${DYNAMODB_POLICY_ARN}" )
    echo ${result}
}

create_dynamodb_policy()
{
    {
        result=$( create_policy "${DYNAMODB_POLICY_NAME}" "${DYNAMODB_POLICY_FILE}" )
    } || {
        error_message "Error creating policy: \"${DYNAMODB_POLICY_NAME}\" \"${DYNAMODB_POLICY_FILE}\".  ${result}"
    }
}

attach_dynamodb_role_policy()
{
    {
        result=$( attach_policy_to_role_policy "${LAMDA_ROLE_NAME}" "${DYNAMODB_POLICY_ARN}" )
        info_message "Policy ${LAMBDA_ROLE_POLICY_ARN} attached to role ${LAMDA_ROLE_NAME}. ${out_message}"
    } || {
        error_message "Error attaching policy ${LAMBDA_ROLE_POLICY_ARN} to role ${LAMDA_ROLE_NAME}.  ${result}"
    }
}

create_lambda_execution_role()
{
    {
        result=$( create_role "${LAMDA_ROLE_NAME}" "${LAMBDA_ROLE_TRUST_POLICY_FILE}" )
        info_message "Role \"${LAMDA_ROLE_NAME}\" using policy file \"${LAMBDA_ROLE_TRUST_POLICY_FILE}\" created. ${result}"
    } || {
        error_message "Error creating role ${LAMDA_ROLE_NAME} using policy file ${LAMBDA_ROLE_TRUST_POLICY_FILE}.  ${result}"
    }
}

attach_execution_policy_to_lambda_role()
{
    {
        result=$( attach_policy_to_role "${LAMDA_ROLE_NAME}" "${LAMBDA_ROLE_POLICY_ARN}" )
        info_message "Policy ${LAMBDA_ROLE_POLICY_ARN} attached to role ${LAMDA_ROLE_NAME}."
    } || {
        error_message "Error attaching policy ${LAMBDA_ROLE_POLICY_ARN} to role ${LAMDA_ROLE_NAME}.  ${result}"
    }
}

attach_dynamodb_policy_to_lambda_role()
{
    {
        result=$( attach_policy_to_role "${LAMDA_ROLE_NAME}" "${DYNAMODB_POLICY_ARN}" )
        info_message "Policy ${DYNAMODB_POLICY_ARN} attached to role ${LAMDA_ROLE_NAME}."
    } || {
        error_message "Error attaching policy ${LAMBDA_ROLE_POLICY_ARN} to role ${LAMDA_ROLE_NAME}.  ${result}"
    }
}
