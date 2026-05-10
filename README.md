# anacron_user

A user-friendly wrapper for anacron that simplifies scheduling recurring tasks on systems where regular cron may not be ideal.

## Requirements

- Python regex module(might change)
- anacron
- Bash
- Linux/Unix-based system

## Installation

1. **Install anacron** (if not already installed):
   ```bash
   # Ubuntu/Debian
   sudo apt-get install anacron
   
   # Fedora/RHEL
   sudo dnf install anacron
   ```

2. **Clone the repository**:
   ```bash
   git clone https://github.com/yoy675/anacron_user.git ~/.anacron
   ```

3. **Choose your setup method**:

   **Option A: systemd (Recommended for most systems)**
   ```bash
   ~/.anacron/install.sh
   ```
   This installs the executable to `~/.local/bin/anacron-user` and enables the systemd service and timer files. Recommended for systems with systemd.

   **Option B: Manual startup (for non-systemd systems)**
   Add this line to your `~/.bashrc`:
   ```bash
   source ~/.anacron/schedule.bash
   ```
   Note: This method does not survive system suspension. Tasks resume only after the next login.

## Usage

Place your cron job scripts in the appropriate `cron.*` folders:

- `cron.daily/` - Scripts that run daily
- `cron.weekly/` - Scripts that run weekly
- `cron.monthly/` - Scripts that run monthly

Example:
```bash
#!/bin/bash
# Create a daily backup script
echo '#!/bin/bash
tar -czf ~/backup.tar.gz ~/important_files/' > ~/.anacron/cron.daily/backup.sh
chmod +x ~/.anacron/cron.daily/backup.sh
```

## License

See LICENSE file for details.

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests.
