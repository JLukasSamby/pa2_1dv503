from data import create_computer, init_database
from mysql.connector import connect, Error
from menus import computer_menu, main_menu
import cursesmenu

# Main routine
if __name__ == "__main__":
    try:
        with connect(
            host="localhost",
            user="root",
            passwd="root"
        ) as cnx:
            init_database(cnx, "computer_builder_lukas_samby")
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
