import pyspark
from delta import *
import json
from pyspark.sql import SparkSession
from pyspark.sql.types import *
from pyspark.sql import types
from pyspark.sql.functions import *
from delta.tables import *
from datetime import datetime
import boto3


class ProcessBronzeData:

    def __init__(self, nam_table, nam_prefix, nam_bucket):
        self.nam_table = nam_table
        self.nam_prefix = nam_prefix
        self.nam_bucket = nam_bucket

    def load_date_partition(self):
        pass

    def init_spark(self):
        builder = pyspark.sql.SparkSession.builder.appName("MyApp") \
            .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
            .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")

        spark = configure_spark_with_delta_pip(builder).getOrCreate()

        return spark

    def load_schema(self, spark, des_schema):

        with open(des_schema, 'r') as f:
            data = json.load(f)

        schemaFromJson = StructType.fromJson(data)

        df = spark.read.csv(
            f"s3://{self.nam_bucket}/{self.nam_prefix}/{self.nam_table}", header=True, schema=schemaFromJson)

        return df

    def load_df_bronze(self, df, key):

        dat_load = datetime.now()
        dat_load = dat_load.strftime('%Y%m%d_%H:%m:%S')
        df = df.withColumn('dat_load', lit(dat_load))

        s3 = boto3.client('s3')
        response = s3.list_objects_v2(
            Bucket=self.nam_bucket, Prefix=self.nam_file)

        if response['KeyCount'] > 1:
            df.write.format("delta").mode("overwrite").save(
                f"s3://{self.nam_bucket}/{self.nam_prefix}/{self.nam_table}")

        else:
            df.write.format("delta").save(
                f"s3://{self.nam_bucket}/{self.nam_prefix}/{self.nam_table}")

        print('Quantidade de registros gravados: ', df.count())


if __name__ == '__main__':
    nam_bucket = 'marvel-bronze-dev'
    nam_file = 'comics'
    nam_prefix = 'raw_data/'
    json_path = '/home/glue_user/workspace/jupyter_workspace/src/bronze_data/schemas'

    process_bronze_data = ProcessBronzeData(
        f"{nam_file}.csv", nam_prefix, '')

    spark = process_bronze_data.init_spark()

    df_raw = process_bronze_data.load_schema(
        spark, f"{json_path}/{nam_file}.json")

    df_export = process_bronze_data.load_df_bronze(df_raw)
