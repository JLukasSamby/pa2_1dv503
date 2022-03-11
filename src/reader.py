from os import scandir
from csv import reader as csv_reader
from pathlib import Path
# Reads data from files


def read_file(path):
    with open(path) as f:
        return f.read()


def read_csvfile(path):
    with open(path) as csvfile:
        return [tuple(row) for row in csv_reader(csvfile)]


def read_schemas():
    children = []
    parents = []
    with scandir("src/sql/schema/children/") as d:
        children = [
            read_file(e.path) for e in d if e.is_file()
        ]
    with scandir("src/sql/schema/parents/") as d:
        parents = [
            read_file(e.path) for e in d if e.is_file()
        ]
    return children + parents


def read_data():
    with scandir("data") as d:
        data = dict()
        for entry in d:
            if entry.is_file():
                tname = Path(entry.path).stem  # Name of table
                data[tname] = read_csvfile(entry.path)
        return data


def read_computer_examples():
    return read_csvfile("data/computer/examples.csv")


def read_name_query(part):
    with open(f"src/sql/queries/computer/name/{part}.sql") as f:
        return f.read()


def read_specsheet():
    with open("src/sql/queries/computer/specs.sql") as f:
        return f.read()


def read_compatibility_query(part):
    with open(f"src/sql/queries/computer/compatibility/{part}.sql") as f:
        return f.read()


def read_functions():
    with scandir("src/sql/functions") as d:
        functions = []
        for entry in d:
            if entry.is_file():
                with open(entry.path) as f:
                    functions.append(f.read())
    return functions


def read_analytics(analytics_factor):
    with open(f"src/sql/queries/computer/analytics/{analytics_factor}.sql") as f:
        return f.read()
