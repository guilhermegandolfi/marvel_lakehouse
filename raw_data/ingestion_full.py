import boto3
import os 
from datetime import datetime
from tqdm import tqdm

class IngestionRawData:


    def __init__(self, bucket, nam_path):
        self.bucket=bucket
        self.nam_path=nam_path

dt= datetime.now()
dt=dt.strftime('year=%y/month=%m/day=%d')


s3_client = boto3.client('s3')
for root, dirs, files in os.walk('../data_files'):
    for name in tqdm(files):
        if name.endswith('.parquet'):
            nam_file=os.path.join(root,name)
            nam_object=nam_file.split('/')
            nam_object=os.path.join('ny_taxis',nam_object[-2],dt,nam_object[-1]) 
            response = s3_client.upload_file(nam_file, 'thanos-lakehouse-raw-data-dev', nam_object)


