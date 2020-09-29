#!/bin/bash

source setup.sh

SRC_DIR="${BASE_DIR}/../src"

clear_lambda_function_package()
{
    rm ${LAMBDA_ZIP_FILE}
}

create_lambda_function_package()
{
    cd ${SRC_DIR} && zip -v -r ${LAMBDA_ZIP_FILE} ./*
}

test_clear_and_package()
{
    clear_lambda_function_package
    create_lambda_function_package
}

#TEST
#test_clear_and_package
