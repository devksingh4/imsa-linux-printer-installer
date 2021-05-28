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

install_bw() {
  echo "Installing IMSAStudentBW..."
  /usr/sbin/lpadmin \
    -p 'IMSAStudentBW' \
    -v 'smb://print.imsa.edu/imsastudentbw' \
    -m 'xrx7830.ppd' \
    -L 'Illinois Mathematics and Science Academy' \
    -o 'Color=Mono' \
    -o 'sides=one-sided' \
    -o 'auth-info-required=negotiate' \
    -E  > /dev/null 2>&1
}
install_color() {
  echo "Installing IMSAStudentColor..."
  /usr/sbin/lpadmin \
    -p 'IMSAStudentColor' \
    -v 'smb://print.imsa.edu/imsastudentcolor' \
    -m 'xrx7830.ppd' \
    -L 'Illinois Mathematics and Science Academy' \
    -o 'auth-info-required=negotiate' \
    -o 'sides=one-sided' \
    -E  > /dev/null 2>&1
}
copy_uninstaller() {
  echo "Copying uninstaller to /usr/share/imsa/printers/uninstall.sh..."
  sudo mkdir -p /usr/share/imsa/printers/
  sudo cp ./uninstall.sh /usr/share/imsa/printers/
  sudo chmod +x /usr/share/imsa/printers/uninstall.sh
}

copy_license() {
  echo "Copying license to /usr/share/imsa/printers/LICENSE..."
  sudo mkdir -p /usr/share/imsa/printers/
  sudo cp ./LICENSE /usr/share/imsa/printers/
}
clear
echo "Welcome to the IMSA Linux Printer Installer"
cat << EOF
IMSA Linux Printer Installer Copyright (C) 2020-2021 Dev Singh
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions; read '/usr/share/imsa/printer/LICENSE' for details.
EOF

# Check if lpadmin lpstat and smbclient are installed
if ! [ -x "$(command -v lpadmin)" ]; then
  echo 'Error: lpadmin is not present. On Ubuntu-based systems, install the cups-client package.' >&2
  exit 1
fi
if ! [ -x "$(command -v lpstat)" ]; then
  echo 'Error: lpadmin is not present. On Ubuntu-based systems, install the lprng package.' >&2
  exit 1
fi
if ! [ -x "$(command -v smbclient)" ]; then
  echo 'Error: smbclient is not present. On Ubuntu-based systems, install the smbclient package.' >&2
  exit 1
fi

# Check to see if the drivers are installed
if [ ! -e /usr/share/cups/model/xrx7830.ppd ]
then
    sudo mkdir -p /usr/share/cups/model
    sudo cp xrx7830.ppd /usr/share/cups/model
    sudo systemctl restart cups
fi

# Check to see if the printer is already installed
if [ `lpstat -p 2>&1 | grep -E 'IMSAStudentBW' -c || true` = "0" ]
then
    if install_bw; then 
      echo "Finished installing IMSAStudentBW!"
    else
      echo "Error installing IMSAStudentBW!"
    fi
else
  echo "Skipping IMSAStudentBW as it is already installed!"
fi

# Now to install IMSA Student Color
if [ `lpstat -p 2>&1 | grep -E 'IMSAStudentColor' -c || true` = "0" ]
then
    if install_color; then 
      echo "Finished installing IMSAStudentColor!"
    else
      echo "Error installing IMSAStudentColor!"
    fi
else
  echo "Skipping IMSAStudentColor as it is already installed!"
fi
copy_uninstaller;
copy_license;