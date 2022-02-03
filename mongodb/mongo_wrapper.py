import pymongo


class MongoWrapper:
    def __init__(self, config):
        """
        Some quick concepts assuming that you have some Python knowledge already:
            PGWrapper is a class. A class is a template for creating objects with user defined properties and methods. An instance is an object created with this class.
            This function is the constructor of the PGWrapper class.
            A class constructor is a special function of a class that is executed whenever we create new objects of that class.
            self is a reference to the object to be created using this class
        Some quick useful links:
            https://realpython.com/python3-object-oriented-programming/
            https://www.edureka.co/blog/self-in-python/

        MongoWrapper constructor. Sets the config property.

        :param config: dict -> Config dictionary with the mongodb database connection parameters.
        """
        self.username = config["user"]
        self.password = config["password"]
        self.authSource = config["database"]
        self.host = config["host"]
        self.client = None

    def connect(self):
        """
        This method uses pymongo to connect to a MongoDB database given the configurations that you passed in the constructor.
        """
        self.client = pymongo.MongoClient(
            self.host,
            username=self.username,
            password=self.password,
            authSource=self.authSource,
        )


if __name__ == "__main__":
    config = {
        "user": "CHANGEME",
        "password": "CHANGEME",
        "database": "CHANGEME",
        "host": "13.40.61.62",
    }
    db_con = MongoWrapper(config)
    db_con.connect()

    mongo_collection = db_con.client.CHANGEME.ucl_messenger
    mongo_collection.insert_one({"this_is_a_test_key": 123})
