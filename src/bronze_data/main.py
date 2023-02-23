from pyspark.sql import SparkSession
from pyspark.sql.types import *
import json
from pyspark.sql import types
from delta import *
from pyspark.sql.functions import *
from delta.tables import *
from pyspark.sql.functions import *
from datetime import datetime

class ProcessBronzeData:

    def __init__(self, nam_file, path_source=None, path_target=None):
        self.path_source = path_source
        self.path_target = path_target
        self.nam_file = nam_file

    def spark_session(self):
        builder = SparkSession.builder.appName("MyApp") \
                    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
                    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")

        spark = configure_spark_with_delta_pip(builder).getOrCreate()
        
        return spark

    def load_schema_file(self,nam_path):
        with open(f"{json_path}/{self.nam_file}.json",'r') as f:
            data = json.load(f)
        schemaFromJson = StructType.fromJson(data)

        return schemaFromJson

    def load_bronze_data_csv(self, spark, schema, header=True):

        df=spark.read.csv(f'{self.path_source}/{self.nam_file}.csv', header=header, schema=schema)
        desc_date=datetime.now()
        desc_date=desc_date.strftime('%Y%m%d')
        df=df.withColumn('dat_load', lit(desc_date))
        df.write.format("delta").mode("overwrite").partitionBy("dat_load").save(f'{self.path_target}/delta/{self.nam_file}')

    def files_to_process(self):
        pass

    def load_bronze_data_merge_csv(self, spark, schema, header=True):

        df=spark.read.csv(f'{self.path_source}/{self.nam_file}.csv', header=header, schema=schema)
        desc_date=datetime.now()
        desc_date=desc_date.strftime('%Y%m%d')
        df=df.withColumn('dat_load', lit(desc_date))
        df.write.format("delta").mode("overwrite").partitionBy("dat_load").save(f'{self.path_target}/delta/{self.nam_file}')
        df.show(10)


if __name__ == '__main__':
    nam_path='..//..//data_set'
    nam_file='characters'
    json_path='schemas'

    bronze_data=ProcessBronzeData(nam_file, nam_path, nam_path)
    spark=bronze_data.spark_session()
    schema=bronze_data.load_schema_file(json_path)
    bronze_data.load_bronze_data_csv(spark, schema)
