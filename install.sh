#!/bin/sh
#  untitled.sh
#
#  Copyright 2026 David Robinson <darobins@g.jct.ac.il>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#
#
sed -i "s|\$HOME|$HOME|g" systemd-services/default.target.wants/anacron-emulator.service
echo "Installing into \`~/.anacron'..."
mkdir -p ~/.anacron ~/.config/systemd/user/
mv systemd-services ~/.config/systemd/user/
mv * ~/.anacron/
echo "Enabling anacron-emulator.service and anacron-emulator.timer..."
systemctl --user enable anacron-emulator.service anacron-emulator.timer
echo "Starting anacron-emulator.timer..."
systemctl --user start anacron-emulator.timer
exit 0