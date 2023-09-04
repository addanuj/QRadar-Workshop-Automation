#!/bin/bash

# Function to create a new group
create_group() {
  echo -n "Enter the name of the group you wish to create: "
  read group_name
  sudo groupadd $group_name
  echo "Group '$group_name' has been created."
}

# Function to create a new user and add to a group
create_user() {
  echo -n "Enter the name of the new user: "
  read user_name
  echo -n "Enter the name of the group to which the user should be added: "
  read group_name
  sudo useradd -G $group_name $user_name
  echo "User '$user_name' has been created and added to group '$group_name'."
}

# Function to set a password for a user
set_password() {
  echo -n "Enter the name of the user for whom you want to set a password: "
  read user_name
  sudo passwd $user_name
}

# Function to verify user details
verify_user() {
  echo -n "Enter the username you wish to verify: "
  read user_name
  id $user_name
}

# Main menu loop
while :
do
  clear
  echo "----------------------------------"
  echo "   User Management Menu"
  echo "----------------------------------"
  echo "[1] Create a new group"
  echo "[2] Create a new user"
  echo "[3] Set a password for a user"
  echo "[4] Verify user details"
  echo "[5] Quit/Exit"
  echo "----------------------------------"
  echo -n "Please enter your choice [1-5]: "
  read choice

  case $choice in
    1) create_group ;;
    2) create_user ;;
    3) set_password ;;
    4) verify_user ;;
    5) exit 0 ;;
    *) echo "Invalid choice, please enter a number between 1 and 5."
  esac

  echo -n "Press [Enter] key to continue..."
  read _
done
