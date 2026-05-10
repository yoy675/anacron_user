#!/bin/sh

sed -i "s|\$HOME|$HOME|g" ~/.anacron/systemd-services/default.target.wants/anacron-user.service
echo "Installing into \`~/.anacron'..."
[ -d ~/.config/systemd/user ] || mkdir -p ~/.config/systemd/user/
mv ~/.anacron/systemd-services/* ~/.config/systemd/user/
[ -d ~/.local/bin ] || mkdir ~/.local/bin
mv ~/.anacron/anacron-user ~/.local/bin/
echo "Enabling anacron-user.service and anacron-user.timer..."
systemctl --user enable anacron-user.service anacron-user.timer
echo "Starting anacron-user.timer..."
systemctl --user start anacron-user.timer
exit 0