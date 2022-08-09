import boto3
import os 
from datetime import datetime
from tqdm import tqdm

class IngestionRawData:

    def __init__(self, bucket, nam_path):
        self.bucket=bucket
        self.nam_path=nam_path

    @staticmethod
    def get_date_now():
        dt= datetime.now()
        dt=dt.strftime('year=%Y/month=%m/day=%d')
        return dt

    def ingestion_files(self, dt, prefix):
        s3_client = boto3.client('s3')
        for root, dirs, files in os.walk(self.nam_path):
            for name in tqdm(files):
                if name.endswith('.parquet'):
                    nam_file=os.path.join(root,name)
                    nam_object=nam_file.split('/')
                    nam_object=os.path.join(prefix,nam_object[-2],dt,nam_object[-1]) 
                    response = s3_client.upload_file(nam_file, self.bucket, nam_object)

if __name__ == '__main__':
    ingestion = IngestionRawData('thanos-lakehouse-raw-data-dev','../data_files')
    dt_now=ingestion.get_date_now()
    ingestion.ingestion_files(dt_now,'ny_taxis')
    

