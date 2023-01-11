from datetime import datetime
from tqdm import tqdm
import logging
import boto3
from botocore.exceptions import ClientError
import os

class IngestionRawData:

    def __init__(self, bucket, nam_path):
        self.bucket = bucket
        self.nam_path = nam_path

    @staticmethod
    def get_date_now():
        dt = datetime.now()
        dt = dt.strftime('year=%Y/month=%m/day=%d')
        return dt

    def ingestion_files(self, dt_now):
        try:
            s3_client = boto3.client('s3')
            for root, dirs, nam_files in os.walk(f'{self.nam_path}'):
                my_list = [os.path.join(x.split(".")[0] , dt_now , x) for x in nam_files if x.endswith('.csv')]
                my_list = [x.lower() for x in my_list]

            for i in my_list:
                nam_file = os.path.join( self.nam_path , i.split('/')[-1])
                response = s3_client.upload_file(nam_file, self.bucket, i)
                print(response)
        except ClientError as e:
            logging.error(e)
        return False

if __name__ == '__main__':
    
    ingestion = IngestionRawData('marvel-bronze-dev','../../data_set')
    dt_now = ingestion.get_date_now()
    ingestion.ingestion_files(dt_now)
        

        

    

