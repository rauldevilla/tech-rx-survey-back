#!/bin/bash

source setup.sh

SRC_DIR="../src"

clear()
{
    rm ${LAMBDA_ZIP_FILE}
}

pack()
{
    cd ${SRC_DIR} && zip -v -r ${LAMBDA_ZIP_FILE} ./*
}

clear
pack
