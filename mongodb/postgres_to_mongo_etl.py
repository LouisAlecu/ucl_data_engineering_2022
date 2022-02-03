# ATTENTION: You will need to change all CHANGEME inside this file
# with your respective credentials
from mongo_wrapper import MongoWrapper
from postgres_wrapper import PGWrapper

# Read on type hinting in Python
# Quick useful link: https://realpython.com/lessons/type-hinting/
from typing import List, Dict, Union


postgres_db_config = {
    "database": "CHANGEME",
    "user": "CHANGEME",
    "password": "CHANGEME",
    "host": "depgdb.crhso94tou3n.eu-west-2.rds.amazonaws.com",
    "port": 5432,
}

mongo_db_config = {
    "user": "CHANGEME",
    "password": "CHANGEME",
    "database": "CHANGEME",
    "host": "13.40.61.62",
}


class ETLPostgresToMongo:
    def __init__(self, postgres_db_config: Dict, mongo_db_config: Dict) -> None:
        """
        Get the database configurations and set them as attributes.

        :param postgres_db_config: dict - postgres database configuration
        :param mongo_db_config: dict - mongo database configuration
        """
        self._postgres_db_config = postgres_db_config
        self._mongo_db_config = mongo_db_config

        self._postgres_db_con = None
        self._mongo_db_con = None

    def connect_to_databases(self) -> None:
        """
        Instantiate the database connection objects
        """
        self._postgres_db_con = PGWrapper(self._postgres_db_config)
        self._mongo_db_con = MongoWrapper(self._mongo_db_config)
        self._postgres_db_con.connect()
        self._mongo_db_con.connect()

    def extract(self, table_schema: str, table: str) -> Dict:
        """
        Get a table schema and table name and retrieve all results
        from Postgres.

        :param table_schema: str - name of the schema the table belongs to
        :param table: str - name of the table

        :return db_results : dict - database results for the specified parameters
        """

        db_results = self._postgres_db_con.query_as_list_of_dicts(
            f""" 
            select * from {table_schema}.{table}
            """
        )
        return db_results

    def transform_users(self, records: List[Dict]) -> Dict:
        transformed_results = {
            "postgres_user_ids": list(map(lambda row: row["user_id"], records)),
            "first_names": list(map(lambda row: row["first_name"], records)),
            "last_names": list(map(lambda row: row["last_name"], records)),
        }
        return transformed_results

    def load(
        self,
        database_name: str,
        mongo_collection_name: str,
        transformed_results: Union[Dict, List[Dict]],
    ) -> None:
        """
        Pass database, collection and records. Insert into mongo.

        :param database_name: str - database name to use
        :param mongo_collection_name: str - collection name to use
        :param transformed_results: Union[Dict, List] - insert records which can be
            1 record as a dictionary or multiple records as a list of dicts
        """
        mongo_db = self._mongo_db_con.client[database_name]
        mongo_collection = mongo_db[mongo_collection_name]

        if isinstance(transformed_results, dict):
            mongo_collection.insert_one(transformed_results)
        elif isinstance(transformed_results, list):
            mongo_collection.insert_many(transformed_results)
        else:
            print("Can not currently deal with any other types than list and dicts.")


if __name__ == "__main__":
    # Instantiating the ETLPostgresToMongo class and connecting to db
    etl = ETLPostgresToMongo(postgres_db_config, mongo_db_config)
    etl.connect_to_databases()

    # Extracting the table users from ucl_messenger schema
    users_postgres = etl.extract(table_schema="ucl_messenger", table="users")

    # Transform the users with a custom function specific for this table
    # If you get another table, you can write your own method to transform it
    users_transformed = etl.transform_users(users_postgres)

    # Load the data into Mongo
    etl.load(
        database_name="CHANGEME",
        mongo_collection_name="ucl_messenger_users",
        transformed_results=users_transformed,
    )
