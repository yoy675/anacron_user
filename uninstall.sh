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

echo "Uninstallation complete!"
echo "Your cron job scripts in ~/.anacron/cron.*/ have been preserved."
exit 0
