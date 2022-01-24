#!/bin/sh
# This file is part of IMSA Linux Printer Installer.

# IMSA Linux Printer Installer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# IMSA Linux Printer Installer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with IMSA Linux Printer Installer.  If not, see <https://www.gnu.org/licenses/>.

uninstall_bw() {
  echo "Uninstalling IMSAStudentBW..."
  lpadmin -x IMSAStudentBW > /dev/null 2>&1
}
uninstall_color() {
  echo "Uninstalling IMSAStudentColor..."
  lpadmin -x IMSAStudentColor > /dev/null 2>&1
}
clear
echo "Welcome to the IMSA Linux Printer Installer - Uninstallation"
cat << EOF
IMSA Linux Printer Installer Copyright (C) 2020-2022 Dev Singh
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions; read '/usr/share/imsa/printer/LICENSE' for details.
EOF

# Check if lpadmin lpstat and smbclient are installed
if ! [ -x "$(command -v lpadmin)" ]; then
  echo 'Error: lpadmin is not present. On Ubuntu-based systems, install the cups-client package.' >&2
  exit 1
fi

# Check to see if the drivers are installed
if [ -e /usr/share/cups/model/xrx7830.ppd ]
then
    sudo rm /usr/share/cups/model/xrx7830.ppd
    sudo systemctl restart cups
fi

# Check to see if the printer is already installed
if [ `lpstat -p 2>&1 | grep -E 'IMSAStudentBW' -c || true` != "0" ]
then
    if uninstall_bw; then 
      echo "Finished uninstalling IMSAStudentBW!"
    else
      echo "Error uninstalling IMSAStudentBW!"
    fi
else
  echo "Skipping IMSAStudentBW as it is not nstalled!"
fi

# Now to install IMSA Student Color
if [ `lpstat -p 2>&1 | grep -E 'IMSAStudentColor' -c || true` != "0" ]
then
    if uninstall_color; then 
      echo "Finished uninstalling IMSAStudentColor!"
    else
      echo "Error uninstalling IMSAStudentColor!"
    fi
else
  echo "Skipping IMSAStudentColor as it is not installed!"
fi
# delete self
sudo rm -- "$0"
sudo rm -rf /usr/share/imsa/printers/