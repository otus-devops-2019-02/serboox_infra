#!/bin/bash
set -e

# Build reddit from source
cd ~
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

# Add service file to systemd
cat <<EOF > /etc/systemd/system/reddit.service
[Unit]
Description=Reddit app from OTUS
After=network.target

[Service]
ExecStart=/usr/local/bin/puma -d --dir /home/appuser/reddit
KillMode=process

Restart=always
RestartSec=5

User=appuser
Group=appuser

PrivateTmp=true
PrivateDevices=true
ProtectSystem=full
ProtectHome=read-only

RuntimeDirectory=reddit
SyslogIdentifier=reddit
SyslogFacility=local0
SyslogLevel=debug

[Install]
WantedBy=multi-user.target
EOF

# Enable reddit
sudo systemctl enable reddit
