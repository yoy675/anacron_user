#!/bin/sh
#  install.sh
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
sed -i "s|\$HOME|$HOME|g" ~/.anacron/systemd-services/default.target.wants/anacron-user.service
echo "Installing into \`~/.anacron'..."
mkdir -p ~/.config/systemd/user/
mv ~/.anacron/systemd-services/*/* ~/.config/systemd/user/
[ -d ~/.local/bin ] || mkdir ~/.local/bin
mv ~/.anacron/anacron-user ~/.local/bin/
echo "Enabling anacron-user.service and anacron-user.timer..."
systemctl --user enable anacron-user.service anacron-user.timer
echo "Starting anacron-user.timer..."
systemctl --user start anacron-user.timer
exit 0