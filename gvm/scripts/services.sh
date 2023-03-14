

#####################################################
#  SYSTEMD SERVICES                                 #
#####################################################

# Systemd service file for ospd-openvas
cat << EOF > $BUILD_DIR/ospd-openvas.service
[Unit]
Description=OSPd Wrapper for the OpenVAS Scanner (ospd-openvas)
Documentation=man:ospd-openvas(8) man:openvas(8)
After=network.target networking.service redis-server@openvas.service mosquitto.service
Wants=redis-server@openvas.service mosquitto.service notus-scanner.service
ConditionKernelCommandLine=!recovery

[Service]
Type=exec
User=gvm
Group=gvm
RuntimeDirectory=ospd
RuntimeDirectoryMode=2775
PIDFile=/run/ospd/ospd-openvas.pid
ExecStart=/usr/local/bin/ospd-openvas --foreground --unix-socket /run/ospd/ospd-openvas.sock --pid-file /run/ospd/ospd-openvas.pid --log-file /var/log/gvm/ospd-openvas.log --lock-file-dir /var/lib/openvas --socket-mode 0o770 --mqtt-broker-address localhost --mqtt-broker-port 1883 --notus-feed-dir /var/lib/notus/advisories
SuccessExitStatus=SIGKILL
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
EOF

# Install systemd service file for ospd-openvas
sudo cp -v $BUILD_DIR/ospd-openvas.service /etc/systemd/system/

# Systemd service file for notus-scanner
cat << EOF > $BUILD_DIR/notus-scanner.service
[Unit]
Description=Notus Scanner
Documentation=https://github.com/greenbone/notus-scanner
After=mosquitto.service
Wants=mosquitto.service
ConditionKernelCommandLine=!recovery

[Service]
Type=exec
User=gvm
RuntimeDirectory=notus-scanner
RuntimeDirectoryMode=2775
PIDFile=/run/notus-scanner/notus-scanner.pid
ExecStart=/usr/local/bin/notus-scanner --foreground --products-directory /var/lib/notus/products --log-file /var/log/gvm/notus-scanner.log
SuccessExitStatus=SIGKILL
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
EOF

# Install systemd service file for notus-scanner
sudo cp -v $BUILD_DIR/notus-scanner.service /etc/systemd/system/

# Systemd service file for gvmd
cat << EOF > $BUILD_DIR/gvmd.service
[Unit]
Description=Greenbone Vulnerability Manager daemon (gvmd)
After=network.target networking.service postgresql.service ospd-openvas.service
Wants=postgresql.service ospd-openvas.service
Documentation=man:gvmd(8)
ConditionKernelCommandLine=!recovery

[Service]
Type=exec
User=gvm
Group=gvm
PIDFile=/run/gvmd/gvmd.pid
RuntimeDirectory=gvmd
RuntimeDirectoryMode=2775
ExecStart=/usr/local/sbin/gvmd --foreground --osp-vt-update=/run/ospd/ospd-openvas.sock --listen-group=gvm
Restart=always
TimeoutStopSec=10

[Install]
WantedBy=multi-user.target
EOF

# Install systemd service file for gvmd
sudo cp -v $BUILD_DIR/gvmd.service /etc/systemd/system/

# Systemd service file for gsad
cat << EOF > $BUILD_DIR/gsad.service
[Unit]
Description=Greenbone Security Assistant daemon (gsad)
Documentation=man:gsad(8) https://www.greenbone.net
After=network.target gvmd.service
Wants=gvmd.service

[Service]
Type=exec
User=gvm
Group=gvm
RuntimeDirectory=gsad
RuntimeDirectoryMode=2775
PIDFile=/run/gsad/gsad.pid
ExecStart=/usr/local/sbin/gsad --foreground --listen=127.0.0.1 --port=9392 --http-only
Restart=always
TimeoutStopSec=10

[Install]
WantedBy=multi-user.target
Alias=greenbone-security-assistant.service
EOF

# Install systemd service file for gsad
sudo cp -v $BUILD_DIR/gsad.service /etc/systemd/system/

# Making systemd aware of the new service files
sudo systemctl daemon-reload

# Ensuring services are run at every system startup
sudo systemctl enable notus-scanner
sudo systemctl enable ospd-openvas
sudo systemctl enable gvmd
sudo systemctl enable gsad

# Downloading the data from the Greenbone Community Feed
sudo /usr/local/bin/greenbone-feed-sync

# Finally starting the services
sudo systemctl start notus-scanner
sudo systemctl start ospd-openvas
sudo systemctl start gvmd
sudo systemctl start gsad

# Checking the status of the services
sudo systemctl status notus-scanner
sudo systemctl status ospd-openvas
sudo systemctl status gvmd
sudo systemctl status gsad

# # ospd-openvas VT loading log message
# Loading VTs. Scans will be [requested|queued] until VTs are loaded. This may
# take a few minutes, please wait ...

# # ospd-openvas VTs loading finished log message
# Finished loading VTs. The VT cache has been updated from version X to Y.

# # gvmd VTs loading log message
# OSP service has different VT status (version X) from database (version (Y), Z VTs). Starting update ...

# # gvmd VTs loading finished log message
# Updating VTs in database ... done (X VTs).

# # gvmd SCAP data loading log message
# update_scap: Updating data from feed

# # gvmd SCAP data loading finished log message
# update_scap_end: Updating SCAP info succeeded

# # gvmd CERT data loading log message
# sync_cert: Updating data from feed

# # gvmd CERT data finished loading log message
# sync_cert: Updating CERT info succeeded.

# # gvmd port list loaded log message
#  Port list All IANA assigned TCP (33d0cd82-57c6-11e1-8ed1-406186ea4fc5) has been created by admin

# # gvmd report format loaded log message
# Report format XML (a994b278-1f62-11e1-96ac-406186ea4fc5) has been created by admin

# # gvmd scan config loaded log message
# Scan config Full and fast (daba56c8-73ec-11df-a475-002264764cea) has been created by admin

# # Opening Greenbone Security Assistant in the browser
# xdg-open "http://127.0.0.1:9392" 2>/dev/null >/dev/null &


set +x