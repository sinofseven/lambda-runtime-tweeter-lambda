const aws_sdk_pacakge = require('aws-sdk/package.json');

exports.handler = async (event) => {
    return [
        `Runtime: ${process.env.AWS_EXECUTION_ENV}`,
        `Node: ${process.versions.node}`,
        `aws-sdk: ${aws_sdk_pacakge.version}`
    ].join("\n");
};
