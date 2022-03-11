from data import init_database
from mysql.connector import connect, Error
from menus import computer_menu, main_menu
from queries import get_create_computer, get_functions, get_specsheet
import cursesmenu

from reader import read_computer_examples


def init(cnx):
    init_database(cnx, "computer_builder_lukas_samby")

    with cnx.cursor() as cursor:
        for func in get_functions():
            cursor.execute(func)
        cursor.execute(get_specsheet())


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


# Main routine
if __name__ == "__main__":
    try:
        with connect(
            host="localhost",
            user="root",
            passwd="root"
        ) as cnx:
            init(cnx)
            create_computer_examples(cnx)
            computer_name, new_computer = main_menu(cnx)
            while computer_name:
                if new_computer:
                    create_computer(cnx, computer_name)
                while computer_menu(cnx, computer_name):
                    pass
                cursesmenu.clear_terminal()
                computer_name, new_computer = main_menu(cnx)
    except Error as e:
        print(e)
