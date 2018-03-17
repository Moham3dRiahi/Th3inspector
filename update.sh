#!/bin/bash

red="\e[0;31m"
green="\e[0;32m"
off="\e[0m"

function banner() {
clear
echo "  _____ _     _____ _                           _";
echo " |_   _| |__ |___ /(_)_ __  ___ _ __   ___  ___| |_ ___  _ __";
echo "   | | | '_ \  |_ \| | '_ \/ __| '_ \ / _ \/ __| __/ _ \| '__|";
echo "   | | | | | |___) | | | | \__ \ |_) |  __/ (__| || (_) | |";
echo "   |_| |_| |_|____/|_|_| |_|___/ .__/ \___|\___|\__\___/|_|";
echo "                               |_|";
echo "  ___             _        _ _           ";
echo " |_ _|  _ __  ___| |_ __ _| | | ___ _ __ ";
echo "  | |  | '_ \/ __| __/ _\` | | |/ _ \ '__|";
echo "  | |  | | | \__ \ || (_| | | |  __/ |   ";
echo " |___| |_| |_|___/\__\__,_|_|_|\___|_|   ";
echo "                                         ";
}

function termux() {
echo -e "$red [$green+$red]$Cleaning Up Old Directories ...";
  rm -r "/data/data/com.termux/files/usr/share/Th3inspector"
  echo -e "$red [$green+$red]$off Installing ...";
  git clone https://github.com/Moham3dRiahi/Th3inspector "/data/data/com.termux/files/usr/share/Th3inspector";
  rm -r "/data/data/com.termux/files/usr/share/Th3inspector/config"

if [ -d "/data/data/com.termux/files/usr/share/Th3inspector" ] ;
then
echo -e "$red [$green+$red]$off Tool Successfully Updated And Will Start In 5s!";
echo -e "$red [$green+$red]$off You can execute tool by typing Th3inspector"
sleep 5;
Th3inspector
else
echo -e "$red [$green✘$red]$off Tool Cannot Be Installed On Your System! Use It As Portable !";
    exit
fi 
}

function linux() {
echo -e "$red [$green+$red]$off Cleaning Up Old Directories ...";
  sudo rm -r "/usr/share/Th3inspector"
  echo -e "$red [$green+$red]$off Installing ...";
 sudo git clone https://github.com/Moham3dRiahi/Th3inspector "/usr/share/Th3inspector";
  sudo rm -r "/usr/share/Th3inspector/config"

if [ -d "/usr/share/Th3inspector" ] ;
then
echo -e "$red [$green+$red]$off Tool Successfully Updated And Will Start In 5s!";
echo -e "$red [$green+$red]$off You can execute tool by typing Th3inspector";
sleep 5;
Th3inspector
else
echo -e "$red [$green✘$red]$off Tool Cannot Be Installed On Your System! Use It As Portable !";
    exit
fi 
}

if [ -d "/data/data/com.termux/files/usr/" ]; then
banner
echo -e "$red [$green+$red]$off Th3inspector Will Be Installed In Your System";
termux
elif [ -d "/usr/bin/" ];then
banner
echo -e "$red [$green+$red]$off Th3inspector Will Be Installed In Your System";
linux
fi
