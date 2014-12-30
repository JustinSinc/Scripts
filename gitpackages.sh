#!/bin/bash

packages=$(sudo pacman -Qq)
package_list=
package_install="sudo pacman -Sy $(sudo pacman -Qq | tr "\n" " ")"

# store list of packages in file for easy install
echo $packages > ./packagelist.txt

# create script to install current system
echo $package_install > ./package_install.sh

