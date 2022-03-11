# Handle correct usage and fetching of queries
from reader import read_name_query, read_specsheet, read_compatibility_query, read_functions, read_analytics


# Generate insert query from name and data
def gen_insert_query(tname, data):
    columns = "("
    for column in data[0]:
        columns += f"{column}, "
    columns = f"{columns[:-2]})"

    data_str = ""
    for row in data[1:]:
        data_str += "("
        for col in row:
            if col != "NULL":
                data_str += f"\"{col}\", "
            else:
                data_str += "NULL, "
        data_str = f"{data_str[:-2]}), "
    data_str = data_str[:-2]

    return f"""\
INSERT INTO
{tname}
{columns}
VALUES
{data_str}\
"""


def gen_insert_queries(data_dict):
    return [
        gen_insert_query(key, val) for key, val in data_dict.items()
    ]


def get_create_computer(name, data_string="NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL"):
    return f"""\
INSERT INTO
computer
(name, cpu_id, ram_id, chassi_id, motherboard_id, gpu_id, power_supply_id, cooler_id, storage_id)
VALUES
("{name}", {data_string})\
"""


def get_part_name(part, id):
    return read_name_query(part).replace("?", str(id))


def get_specsheet():
    return read_specsheet()


def get_compatibility_query(computer_name, part):
    return read_compatibility_query(part).replace("?", f"'{computer_name}'")


def get_functions():
    return read_functions()


def get_select_part_query(computer_name, part, part_id):
    return f"""\
UPDATE computer c
SET
    {part}_id = {part_id}
WHERE
    c.name = '{computer_name}'\
"""


def get_analytics(analytics_factor):
    return read_analytics(analytics_factor)
