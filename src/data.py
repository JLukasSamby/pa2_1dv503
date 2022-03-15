from mysql.connector import Error, errorcode
from reader import read_schemas, read_data, read_computer_examples
from queries import gen_insert_queries, gen_insert_query, get_create_computer, get_functions, get_specsheet


def create_computer(cnx, computer_name):
    with cnx.cursor() as cursor:
        cursor.execute(get_create_computer(computer_name))


def create_computer_examples(cnx):
    data = read_computer_examples()
    data_dict = dict()
    for d in data[1:]:
        s = ""
        for e in d[1:]:
            s += f"{e}, "
        data_dict[d[0]] = s[:-2]
    with cnx.cursor() as cursor:
        for key, val in data_dict.items():
            cursor.execute(get_create_computer(key, data_string=val))


# Main routine for creating database and its entries
def init_database(cnx, dbname):
    if not use_database(cnx, dbname):
        create_database(cnx, dbname)
        use_database(cnx, dbname)
        create_tables(cnx)
        with cnx.cursor() as cursor:
            for func in get_functions():
                cursor.execute(func, multi=True)
            cursor.execute(get_specsheet())
        create_computer_examples(cnx)


# Initialzing the database if it does not exist
def create_database(cnx, dbname):
    CREATE_DB_QUERY = f"CREATE DATABASE {dbname}"
    with cnx.cursor() as cursor:
        cursor.execute(CREATE_DB_QUERY)


# Use database
def use_database(cnx, dbname):
    USE_QUERY = f"USE {dbname}"
    with cnx.cursor() as cursor:
        try:
            cursor.execute(USE_QUERY)
            cnx.database = dbname
            return True
        except Error as e:
            if e.errno == errorcode.ER_BAD_DB_ERROR:  # Unknown database
                return False
            else:
                print(e)
                exit(1)


# Create the tables
def create_tables(cnx):
    with cnx.cursor() as cursor:
        # Create tables from schema
        for schema in read_schemas():
            cursor.execute(schema)

        # Populate tables from csv files
        data = read_data()
        for insert_query in gen_insert_queries(data):
            cursor.execute(insert_query)
            cursor.execute("COMMIT")


# Shows all databases
def show_databases(cnx):
    SHOW_QUERY = "SHOW DATABASES"
    with cnx.cursor() as cursor:
        cursor.execute(SHOW_QUERY)
        for db in cursor:
            print(db)


# Show all tables
def show_tables(cnx):
    SHOW_QUERY = "SHOW TABLES"
    with cnx.cursor() as cursor:
        cursor.execute(SHOW_QUERY)
        if not cursor:
            print('empty')
        for tl in cursor:
            print(tl)
