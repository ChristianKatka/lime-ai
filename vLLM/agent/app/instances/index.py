import boto3

def get_sqs_client():
    return boto3.client("sqs", region_name="eu-north-1")