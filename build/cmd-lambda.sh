#!/bin/bash

source setup.sh $1
source aws-lib/lambda.sh
source aws-lib/account.sh

STAGE=$( get_stage )

AWS_ACCOUNT_ID=$( get_account_id "Tech And Solve" )

FUNCTION_NAME="rxsurvey-proxy"
FUNCTION_HANDLER="handler"
FUNCTION_RUNTIME="nodejs12.x"
FUNCTION_ZIP_FILE="fileb://${BASE_DIR}/out/package/package-lambda.zip"
FUNCTION_ROLE="arn:aws:iam::${AWS_ACCOUNT_ID}:role/${LAMDA_ROLE_NAME}"

update_proxy_function()
{
    result=$( update_function_code "${FUNCTION_NAME}" "${FUNCTION_ZIP_FILE}" )
    revision_id=$( echo ${result} | jq -r .RevisionId )
    if [ "${revision_id}" != "" ]; then
        info_message "Function "${FUNCTION_NAME}" updated using file "${FUNCTION_ZIP_FILE}".  [${revision_id}] Result ${result}"
    else
        error_message "Error updating function "${FUNCTION_NAME}" from file "${FUNCTION_ZIP_FILE}". ${result}"
    fi
}

create_proxy_function()
{
    result=$( check_if_function_exists "${FUNCTION_NAME}" )
    if [ "${result}" == "" ]; then
        result=$( create_function "${FUNCTION_NAME}" "${FUNCTION_RUNTIME}" "${FUNCTION_ZIP_FILE}" "${FUNCTION_HANDLER}" "${FUNCTION_ROLE}" )
        revision_id=$( echo ${result} | jq -r .RevisionId )
        if [ "${result}" != "" ]; then
            info_message "Function "${FUNCTION_NAME}" creted using file "${FUNCTION_ZIP_FILE}". [${revision_id}]."

            env_vars="{STAGE=${STAGE}}"
            result=$( add_env_variables_to_function "${FUNCTION_NAME}" "${env_vars}" )
            if [ result != "" ]; then
                info_message "Environment variables ${env_vars} added to "${FUNCTION_NAME}""
            else
                error_message "Error adding environment variables ${env_vars} to function "${FUNCTION_NAME}".  ${result}"
            fi

        else
            error_message "Error creating function "${FUNCTION_NAME}" from file "${FUNCTION_ZIP_FILE}". ${result}"
        fi
    else
        warn_message "Function "${FUNCTION_NAME}" already exists."
    fi
}

delete_proxy_function()
{
    result=$( check_if_function_exists "${FUNCTION_NAME}" )
    if [ "${result}" != "" ]; then
        {
            result=$( delete_function "${FUNCTION_NAME}" )
            info_message "Function ${FUNCTION_NAME} deleted. ${result}"
        } || {
            error_message "Error deleting function ${FUNCTION_NAME}.  ${result}"
        }
    else
        warn_message "Function "${FUNCTION_NAME}" does NOT exist."
    fi
}
