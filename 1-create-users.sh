#!/bin/bash

# QRadar Workshop Manager

# Function to create a user
create_user() {
  username=$1
  password="Workshop@123"
  useradd -G workshop $username
  echo -e "$password\n$password" | passwd $username &> /dev/null
  printf "| %-10s | %-15s |\n" $username $password
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
read -p "Select an option (1/2): " option

# Initialize table header
printf "| %-10s | %-15s |\n" "Username" "Password"
printf "|%11s|%16s|\n" "-----------" "----------------"

case $option in
  1)
    read -p "Enter the username: " username
    create_user $username
    ;;
  2)
    read -p "Enter the number of users to create: " num_users
    read -p "Warning: This will create $num_users users with the password 'Workshop@123'. Do you want to continue? (y/n): " confirm
    if [ "$confirm" == "y" ]; then
      for i in $(seq 1 $num_users); do
        create_user "user$i"
      done
    else
      echo "User creation cancelled."
    fi
    ;;
  *)
    echo "Invalid option. Exiting."
    ;;
esac
