import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))
    
    for record in event.get('Records', []):
        if 's3' in record:
            bucket = record['s3']['bucket']['name']
            key = record['s3']['object']['key']
            print(f"Image received: {key}")
            logger.info(f"Image received: {key}")
    
    return {
        'statusCode': 200,
        'body': json.dumps('Successfully processed S3 event.')
    }
