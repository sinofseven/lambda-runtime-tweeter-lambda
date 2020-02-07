import boto3
from botocore.client import BaseClient
from jeffy.framework import setup
from twitter import Api

app = setup()


def main(event: dict, ssm_client: BaseClient = boto3.client("ssm")):
    app.logger.info({"name": "event", "value": event})
    keys = get_keys(ssm_client)
    message = get_message(event)
    tweet(message, keys)


def get_keys(ssm_client: BaseClient) -> dict:
    option = {"Path": "/twitter/keys", "WithDecryption": True}
    resp = ssm_client.get_parameters_by_path(**option)
    keys = {x["Name"]: x["Value"] for x in resp["Parameters"]}
    return {
        "consumer_key": keys["/twitter/keys/consumer_key"],
        "consumer_secret": keys["/twitter/keys/consumer_secret"],
        "access_token_key": keys["/twitter/keys/access_token_key"],
        "access_token_secret": keys["/twitter/keys/access_token_secret"],
    }


def get_message(event: dict) -> str:
    return event["responsePayload"]


def tweet(message: str, keys: dict):
    resp = Api(**keys).PostUpdate(message)
    app.logger.info({"name": "tweet response", "value": resp})
