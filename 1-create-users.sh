#!/bin/bash

# QRadar Workshop Manager

# Function to create a user
create_user() {
  username=$1
  password="Workshop@123"
  if useradd -G workshop $username; then
    echo -e "$password\n$password" | passwd $username &> /dev/null
    printf "| %-10s | %-15s |\n" $username $password
  else
    echo "User $username already exists."
  fi
}

# Function to delete a user
delete_user() {
  username=$1
  if [ -z "$username" ]; then
    echo "No username provided."
    return
  fi
  if [ "$username" != "root" ]; then
    userdel -r $username &> /dev/null && echo "User $username deleted." || echo "User $username could not be deleted."
  else
    echo "Cannot delete root user."
  fi
}

# Function to reset a user's password
reset_password() {
  username=$1
  if [ -z "$username" ]; then
    echo "No username provided."
    return
  fi
  new_password="Workshop@123"
  if [ "$username" != "root" ]; then
    echo -e "$new_password\n$new_password" | passwd $username &> /dev/null && echo "Password for $username reset to $new_password." || echo "Could not reset password for $username."
  else
    echo "Cannot reset password for root user."
  fi
}

# Function to list all users
list_users() {
  echo "Listing all users:"
  getent passwd | cut -d: -f1
}

# Create workshop group if it doesn't exist
if ! getent group workshop > /dev/null; then
  groupadd workshop
  echo "Group 'workshop' created."
fi

# Menu
echo "QRadar Workshop Manager"
echo "1. Create Single User"
echo "2. Create Multiple Users"
echo "3. Delete User"
echo "4. Set Default Password for a user"
echo "5. List All Users"
read -p "Select an option (1/2/3/4/5): " option

case $option in
  1)
    read -p "Enter the username: " username
    if [ -n "$username" ]; then
      # Initialize table header
      printf "| %-10s | %-15s |\n" "Username" "Password"
      printf "|%11s|%16s|\n" "-----------" "----------------"
      create_user $username
    else
      echo "No username provided. Exiting."
    fi
    ;;
  2)
    read -p "Enter the number of users to create: " num_users
    read -p "Warning: This will create $num_users users with the password 'Workshop@123'. Do you want to continue? (y/n): " confirm
    if [ "$confirm" == "y" ]; then
      # Initialize table header
      printf "| %-10s | %-15s |\n" "Username" "Password"
      printf "|%11s|%16s|\n" "-----------" "----------------"
      for i in $(seq 1 $num_users); do
        create_user "user$i"
      done
    else
      echo "User creation cancelled."
    fi
    ;;
  3)
    read -p "Enter the username to delete: " username
    delete_user $username
    ;;
  4)
    read -p "Enter the username for which to Set Default Password for a user: " username
    reset_password $username
    ;;
  5)
    list_users
    ;;
  *)
    echo "Invalid option. Exiting."
    ;;
esac
