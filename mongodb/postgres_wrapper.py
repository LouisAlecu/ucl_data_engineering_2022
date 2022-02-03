import pg8000
from schema import Schema, And

database_config_validator = Schema(
    {
        "database": And(
            str,
            error="database parameter is required and must be a str",
        ),
        "port": And(
            int,
            error="port is required and must be an int",
        ),
        "password": And(str, error="password parameter is required and must be a str"),
        "host": And(str, error="host parameter is required and must be a str"),
        "user": And(str, error="user parameter is required and must be a str"),
    }
)


class PGWrapper:
    def __init__(self, config: dict, autocommit: bool = True) -> None:
        """
        Some quick concepts assuming that you have some Python knowledge already:
            PGWrapper is a class. A class is a template for creating objects with user defined properties and methods. An instance is an object created with this class.
            This function is the constructor of the PGWrapper class.
            A class constructor is a special function of a class that is executed whenever we create new objects of that class.
            self is a reference to the object to be created using this class
        Some quick useful links:
            https://realpython.com/python3-object-oriented-programming/
            https://www.edureka.co/blog/self-in-python/

        PGWrapper constructor. Validates if the passed config follows the expected schema and sets the __autocommit and __config properties.

        :param config: dict -> Config dictionary with the postgres database connection parameters.
                            It must follow the schema in the database_config_validator object defined above
        :param autocommit: bool -> Boolean value that can be set to False if you want more control on committing database transactions
        """
        self.__autocommit = autocommit
        self.__config = database_config_validator.validate(config)

    def __enter__(self):
        """
        This is magic method in Python called a dunder. It adds extra functionality to your instances created with this class.
        This particular dunder implements a context manager in Python and it allows you to write code as following:
            with PGWrapper(config) as db_con:
                results = db_con.query_as_list_of_dicts("SELECT * FROM information_schema.schemata")
        Whilst the usual way (which you can still use anyway) would be:
            db_con = PGWrapper(config)
            db_con.connect()
            results = db_con.query_as_list_of_dicts("SELECT * FROM information_schema.schemata")

        The benefits of using a context manager is that the Python Garbage Collector (quick useful link https://towardsdatascience.com/memory-management-and-garbage-collection-in-python-c1cb51d1612c)
        cleans the instance created with this class as soon as its context is finished. At the end it runs code that you implement in the __exit__ dunder.
        In the case of a database connection you might want to add a connect_to_some_db() in the __enter__ and a close_some_db_connection() in the __exit__ dunder.

        Some quick useful links:
            https://www.section.io/engineering-education/dunder-methods-python/
            https://book.pythontips.com/en/latest/context_managers.html (context manager, a bit more advanced topic)
        """
        return self.connect()

    def __exit__(self, type, value, traceback):
        """
        Attempts to close the connection on exit from the context manager. It uses the self.close method defined below.

        Some quick information:
            A contextmanager class is any class that implements the __enter__ and __exit__ methods according to the Python Language Reference’s context management protocol.
            Implementing the context management protocol enables you to use the with statement with instances of the class. The with statement is used to ensure that setup
            and teardown operations are always executed before and after a given block of code.
            It is functionally equivalent to try...finally blocks, except that with statements are more concise.

            The parameters of this method describe the exception that caused the context to be exited.
            If the context was exited without an exception, all three arguments will be None.
        """
        self.close()

    def connect(self):
        """
        This is the method used to connect to the database, set the autocommit flag and open a cursor.
        The cursor is what actually writes and reads from the database and passes back the response to Python.
        """
        self.cnx = pg8000.connect(**self.__config)
        self.cnx.autocommit = self.__autocommit
        self.cursor = self.cnx.cursor()
        return self

    def close(self):
        """
        Method to close the connection to the database.
        """
        try:
            self.cursor.close()
            self.cnx.close()
        except Exception:
            pass

    def query(self, sql, parameters=tuple()):
        """
        Uses the cursor to execute a SQL query with some given parameters as a tuple, then fetches all results and returns them.
        """
        self.cursor.execute(sql, parameters)
        results = self.cursor.fetchall()
        return results

    def query_as_list_of_dicts(self, sql, parameters=tuple()):
        """
        Same as query but returns the data as a list of dictionaries.
        """
        self.cursor.execute(sql, parameters)
        results = []
        if self.cursor.description:
            cols = [h[0] for h in self.cursor.description]
            for row in self.cursor.fetchall():
                results.append({a: b for a, b in zip(cols, row)})
        return results

    def commit(self):
        """
        If autocommit is set to false, you need to use this method to commit any changes you do on the database, otherwise they won't be applied.
        """
        self.cnx.commit()

    def rollback(self):
        """
        You can roll back a transaction that you have done and for any reason do not want to be applied to the database anymore.
        """
        self.cnx.rollback()


config = {
    "database": "CHANGEME",
    "user": "CHANGEME",
    "password": "CHANGEME",
    "host": "depgdb.crhso94tou3n.eu-west-2.rds.amazonaws.com",
    "port": 5432,
}


def quick_test_without_context_manager():
    """
    Example of how to connect to the database without a context manager.
    """
    db_con = PGWrapper(config)
    db_con.connect()
    results = db_con.query_as_list_of_dicts("SELECT * FROM information_schema.schemata")
    print(results)
    return results


def quick_test_with_context_manager():
    """
    Example of how to connect to the database with a context manager.
    """
    with PGWrapper(config) as db_con:
        results = db_con.query_as_list_of_dicts(
            "SELECT * FROM information_schema.schemata"
        )
        print(results)
    return results


if __name__ == "__main__":
    quick_test_with_context_manager()
    print("----")
    quick_test_without_context_manager()
