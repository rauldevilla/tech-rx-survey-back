#!/bin/bash

source setup.sh
source aws-lib/lambda.sh

FUNCTION_NAME="rxsurvey-proxy"
FUNCTION_HANDLER="handler"
FUNCTION_RUNTIME="nodejs12.x"
FUNCTION_ZIP_FILE="fileb://${BASE_DIR}/out/package/package-lambda.zip"

#FUNCTION_ROLE="arn:aws:iam::123456789012:role/lambda-dynamodb-role"

#create_proxy_lambda_function()
#{
#
#
#
#
#
#   {
#        output_message=$( {
#                    aws lambda create-function \
#                    --function-name ${FUNCTION_NAME} \
#                    --zip-file fileb://${LAMBDA_ZIP_FILE} \
#                    --handler ${FUNCTION_HANDLER} \
#                    --runtime ${FUNCTION_RUNTIME} \
#                    --role ${FUNCTION_ROLE}; } 2>&1)
#
#        info_message "Lambda function ${FUNCTION_NAME} created."
#   } || {
#       error_message "Error creating lambda function ${FUNCTION_NAME}.  ${output_message}"
#   }
#}
#

update_proxy_function()
{
    {
        result=$( update_function_code "${FUNCTION_NAME}" "${FUNCTION_ZIP_FILE}")
        info_message "Function "${FUNCTION_NAME}" creted using file "${FUNCTION_ZIP_FILE}"."
    } || {
        error_message "Error updating function "${FUNCTION_NAME}" from file "${FUNCTION_ZIP_FILE}".  ${result}"
    }
}