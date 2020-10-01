'use strict'

exports.handler = (event) => {

    return {
        statusCode: 201,
        body: JSON.stringify("Ahi vamosssss\'" + process.env.STAGE)
    }

};
