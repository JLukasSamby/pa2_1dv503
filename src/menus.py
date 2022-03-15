# Handle display of data, information and input
from queries import get_compatibility_query, get_part_name, get_select_part_query, get_analytics
from cursesmenu import CursesMenu, SelectionMenu
from cursesmenu.items import FunctionItem, SubmenuItem, MenuItem


def help_menu(computer_name):
    return SelectionMenu(
        [
            "Part: Pick a part to see modification menu",
            "Save computer: Save the current computer to the database",
            "See specsheet: See a short representation of the computer and its parts",
            "Exit: Exit the computer builder"
        ],
        title=f"Computer build {computer_name}",
        subtitle="Help descriptions: (press enter to go back)"
    )


def help_mod_menu(part):
    return SelectionMenu(
        [
            "Select: Choose a new compatible part",
            "Remove: Remove the current selection",
            "List all: Display a list of all parts, compatible or not"
        ],
        title=f"Modification Menu ({part})",
        subtitle="Help descriptions: (press enter to go back)"
    )


def specs_menu(cnx, computer_name):
    with cnx.cursor() as cursor:
        cursor.execute(f"SELECT * FROM specsheet WHERE ComputerName = '{computer_name}'")
        return SelectionMenu(
            [
                "{:<8} | {}".format(desc[0], row)
                for (row, desc)
                in zip(cursor.fetchall()[0][1:], cursor.description[1:])
                if row
            ],
            title=f"Computer build {computer_name}",
            subtitle="Specsheet:"
        )


def select_menu(cnx, computer_name, part):
    menu = CursesMenu(
        title=f"Select a {part} for {computer_name}",
        subtitle="Compatible parts below:"
    )

    with cnx.cursor() as cursor:
        cursor.execute(get_compatibility_query(computer_name, part))

        for row in cursor.fetchall():
            menu.append_item(FunctionItem(
                get_part_name_string(cnx, part, row[0]),
                select_part,
                [cnx, computer_name, part, row[0]],
                menu=menu,
                should_exit=True
            ))

    return menu


def select_part(cnx, computer_name, part, part_id):
    with cnx.cursor() as cursor:
        cursor.execute(get_select_part_query(computer_name, part, part_id))


def remove_part(cnx, computer_name, part):
    with cnx.cursor() as cursor:
        cursor.execute(get_select_part_query(computer_name, part, 'NULL'))


def save_function(cnx):
    with cnx.cursor() as cursor:
        cursor.execute('COMMIT')


def list_menu(cnx, part):
    with cnx.cursor() as cursor:
        cursor.execute(f"SELECT * FROM {part}")
        return SelectionMenu([
            get_part_name_string(
                cnx, part, row[0]
            ) for row in cursor.fetchall()
        ])


def modification_menu(cnx, computer_name, part):
    menu = CursesMenu(
        title=f"Modification Menu ({part})",
        subtitle=f"Currently modifying {part}..."
    )
    menu.append_item(SubmenuItem(
        "Select New",
        select_menu(cnx, computer_name, part),
        menu=menu,
        should_exit=True
    ))
    menu.append_item(FunctionItem(
        "Remove Selection",
        remove_part,
        [cnx, computer_name, part],
        menu=menu,
        should_exit=True
    ))
    menu.append_item(SubmenuItem(
        "Liist All",
        list_menu(cnx, part),
        menu=menu,
        should_exit=True
    ))
    menu.append_item(SubmenuItem(
        "Help",
        help_mod_menu(part),
        menu=menu
    ))
    return menu


def computer_menu(cnx, computer_name):
    menu_entries = []
    # Get the Field names and results for the current computer worked on
    with cnx.cursor() as cursor:
        cursor.execute(
            f"SELECT * FROM computer WHERE computer.name = \"{computer_name}\""
        )
        ids = cursor.fetchall()[0][1:]
        names_of_parts = [i[0].replace("_id", '') for i in cursor.description][1:]

    for (part, part_id) in zip(names_of_parts, ids):
        menu_entries.append(
            "{:<12} | {}".format(
                part,
                get_part_name_string(cnx, part, part_id)
            )
        )

    menu = CursesMenu(
        title=f"Computer build {computer_name}",
        subtitle="Select a part for options"
    )

    for (part, entry) in zip(names_of_parts, menu_entries):
        menu.append_item(SubmenuItem(
            entry,
            modification_menu(cnx, computer_name, part),
            menu=menu,
            should_exit=True
        ))

    menu.append_item(FunctionItem(
        "Save computer",
        save_function,
        [cnx],
        menu=menu,
        should_exit=True
    ))
    menu.append_item(SubmenuItem(
        "See specsheet",
        specs_menu(cnx, computer_name),
        menu=menu
    ))
    menu.append_item(SubmenuItem(
        "Help",
        help_menu(computer_name),
        menu=menu
    ))

    menu.show()
    return menu.selected_option != 11


def get_part_name_string(cnx, part, part_id):
    if not part_id:
        return ''
    with cnx.cursor() as cursor:
        cursor.execute(get_part_name(part, part_id))
        s = ""
        for res in cursor.fetchall()[0]:
            s += f"{res} "
    return s


def computer_list_menu(cnx, computers):
    return SelectionMenu([c[0] for c in computers], title="List Menu", subtitle="Select a computer to edit...")


def computer_spec_list_menu(cnx, computers):
    menu = CursesMenu(
        title="Spec List Menu",
        subtitle="Select Computer to see specs..."
    )

    for computer in computers:
        name = computer[0]
        menu.append_item(SubmenuItem(
            name,
            specs_menu(cnx, name),
            menu=menu
        ))

    return menu


def main_menu(cnx):
    with cnx.cursor() as cursor:
        cursor.execute("SELECT name FROM computer")
        computers = cursor.fetchall()

    menu = CursesMenu(
        title="Main Menu",
        subtitle="Please select an option..."
    )

    menu.append_item(FunctionItem(
        "Create Computer",
        eval,
        ['-1'],
        menu=menu,
        should_exit=True
    ))

    if computers:
        menu.append_item(SubmenuItem(
            "List Computers",
            computer_list_menu(cnx, computers),
            menu=menu
        ))
        menu.append_item(SubmenuItem(
            "Edit Computer",
            computer_list_menu(cnx, computers),
            menu=menu,
            should_exit=True
        ))
        menu.append_item(SubmenuItem(
            "See specs",
            computer_spec_list_menu(cnx, computers),
            menu=menu,
            should_exit=False
        ))
        menu.append_item(FunctionItem(
            "Save",
            save_function,
            [cnx],
            menu=menu
        ))
        menu.append_item(SubmenuItem(
            "Analytics",
            computer_analytics_menu(cnx),
            menu=menu
        ))

    menu.show()
    idx = menu.returned_value
    if idx is None:
        return '', False
    if idx >= 0:
        return computers[idx][0], False
    else:
        return input("Please enter a name for the new computer: "), True


def computer_analytics_menu(cnx):
    menu = CursesMenu(
        title="Analytics Menu",
        subtitle="Select an analytics factor below:"
    )
    menu.append_item(SubmenuItem(
        "Processor Series",
        analytics_menu(cnx, "cpu_series"),
        menu=menu
    ))
    menu.append_item(SubmenuItem(
        "Ram Amount",
        analytics_menu(cnx, "ram_amount"),
        menu=menu
    ))
    menu.append_item(SubmenuItem(
        "Power",
        analytics_menu(cnx, "power"),
        menu=menu
    ))
    menu.append_item(SubmenuItem(
        "Price Range",
        analytics_menu(cnx, "price_range"),
        menu=menu
    ))
    return menu


def analytics_menu(cnx, analysis_factor):
    with cnx.cursor() as cursor:
        cursor.execute(get_analytics(analysis_factor))
        menu = CursesMenu(
            title="Analytics Menu",
            subtitle=f"Analytics for {analysis_factor}..."
        )
        for row in cursor.fetchall():
            if len(row) > 2 and row[0]:
                menu.append_item(MenuItem(
                    f"{row[1]} {row[2]}: {row[0]}"
                ))
            elif row[0]:
                menu.append_item(MenuItem(
                    f"{row[1]}: {row[0]}"
                ))

        return menu
