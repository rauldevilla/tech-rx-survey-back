#!/bin/bash

source setup.sh $1
source aws-lib/dynamodb.sh

STAGE=$( get_stage )

create_survey_table()
{
    result=$( check_if_table_exists "${TABLE_SURVEY_NAME}" )
    if [ "${result}" == "" ]; then

        table_attributs_definition="AttributeName=SurveyId,AttributeType=S"
        key_schema="AttributeName=SurveyId,KeyType=HASH"
        result=$( create_dynamodb_create "${TABLE_SURVEY_NAME}" ${table_attributs_definition} ${key_schema} )
        if [ "${result}" != "" ]; then
            info_message "Table \"${TABLE_SURVEY_NAME}\" created."
        else
            error_message "Error creating table \"${TABLE_SURVEY_NAME}\"."
        fi

    else
        warn_message "Table \"${TABLE_SURVEY_NAME}\" already exists."
    fi
}

delete_survey_table()
{
    result=$( check_if_table_exists "${TABLE_SURVEY_NAME}" )
    if [ "${result}" != "" ]; then

        result=$( delete_dynamodb_table "${TABLE_SURVEY_NAME}" )
        if [ "${result}" != "" ]; then
            info_message "Table \"${TABLE_SURVEY_NAME}\" delete."
        else
            error_message "Error deleting table \"${TABLE_SURVEY_NAME}\"."
        fi

    else
        warn_message "Table \"${TABLE_SURVEY_NAME}\" does NOT exist."
    fi
}
