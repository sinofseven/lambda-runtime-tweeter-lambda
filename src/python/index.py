import sys
import boto3
import botocore
import os


def handler(event, context):
    return '\n'.join([
        f'Runtime: {os.getenv("AWS_EXECUTION_ENV")}',
        f'Python: {sys.version}',
        f'boto3: {boto3.__version__}',
        f'botocore: {botocore.__version__}'
    ])
