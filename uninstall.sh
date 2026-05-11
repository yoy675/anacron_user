#!/bin/sh
#  uninstall.sh
#
#  Remove anacron_user installation

echo "Stopping and disabling anacron-user services..."
systemctl --user stop anacron-user.timer 2>/dev/null
systemctl --user disable anacron-user.service anacron-user.timer 2>/dev/null

echo "Removing anacron-user executable..."
rm -f ~/.local/bin/anacron-user

echo "Removing systemd service files..."
rm -rf ~/.config/systemd/user/anacron-user.service
rm -rf ~/.config/systemd/user/anacron-user.timer

echo -e "\nWARNING: This will delete ~/.anacron and ALL cron job scripts!"
read -p "Are you sure? (yes/no) " response
if [ "$response" = "yes" ]; then
    rm -rf ~/.anacron
    echo "~/.anacron removed."
else
    echo "~/.anacron preserved."
fi

echo "Uninstallation complete!"
exit 0
