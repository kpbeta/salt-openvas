Setup logs:
    cmd.run:
        - name: mkdir -p /salt-openvas-log
        - order: 01

Run Prereqs:
    cmd.run:
        - name: /srv/salt/gvm/scripts/prereqs.sh > /salt-openvas-log/prereqs_install_out.log 2>&1
        - order: 10

See variables:
    cmd.run:
        - name: /srv/salt/gvm/scripts/gvm_libs.sh >> /salt-openvas-log/vars_install_out.log 2>&1
        - order: 20

GVMD:
    cmd.run:
        - name: /srv/salt/gvm/scripts/gvmd.sh >> /salt-openvas-log/gvmd_install_out.log 2>&1
        - order: 30

PG-GVM:
    cmd.run:
        - name: /srv/salt/gvm/scripts/pg_gvm.sh >> /salt-openvas-log/pggvm_install_out.log 2>&1
        - order: 40

GSA:
    cmd.run:
        - name: /srv/salt/gvm/scripts/gsa.sh >> /salt-openvas-log/gsa_install_out.log 2>&1
        - order: 50

GSAD:
    cmd.run:
        - name: /srv/salt/gvm/scripts/gsad.sh >> /salt-openvas-log/gsad_install_out.log 2>&1
        - order: 60

OpenVAS SMB:
    cmd.run:
        - name: /srv/salt/gvm/scripts/openvas_smb.sh >> /salt-openvas-log/opnvas_smb_install_out.log 2>&1
        - order: 70

OpenVAS Scanner:
    cmd.run:
        - name: /srv/salt/gvm/scripts/openvas_scanner.sh > /salt-openvas-log/openvas_scan_install_out.log 2>&1
        - order: 80

OSPD OpenVAS:
    cmd.run:
        - name: /srv/salt/gvm/scripts/ospd_openvas.sh >> /salt-openvas-log/ospd_openvas_install_out.log 2>&1
        - order: 90

Notus Scanner:
    cmd.run:
        - name: /srv/salt/gvm/scripts/notus_scanner.sh >> /salt-openvas-log/notus_scanner_install_out.log 2>&1
        - order: 100

Greenbone Feed Sync:
    cmd.run:
        - name: /srv/salt/gvm/scripts/greenbone_feed_sync.sh >> /salt-openvas-log/feedsync_install_out.log 2>&1
        - order: 110

GVM Tools:
    cmd.run:
        - name: /srv/salt/gvm/scripts/gvm_tools.sh >> /salt-openvas-log/gvm_tools_install_out.log 2>&1
        - order: 120

Redis:
    cmd.run:
        - name: /srv/salt/gvm/scripts/redis.sh >> /salt-openvas-log/redis_install_out.log 2>&1
        - order: 130

Mosquitto:
    cmd.run:
        - name: /srv/salt/gvm/scripts/mosquitto.sh >> /salt-openvas-log/mosquitto_install_out.log 2>&1
        - order: 140

Directory:
    cmd.run:
        - name: /srv/salt/gvm/scripts/directory.sh >> /salt-openvas-log/dirs_install_out.log 2>&1
        - order: 150

Feed Validation:
    cmd.run:
        - name: /srv/salt/gvm/scripts/feed_validation.sh >> /salt-openvas-log/feed_valid_install_out.log 2>&1
        - order: 160

PGSQL:
    cmd.run:
        - name: /srv/salt/gvm/scripts/pgsql.sh >> /salt-openvas-log/pgsql_install_out.log 2>&1
        - order: 170

Admin:
    cmd.run:
        - name: /srv/salt/gvm/scripts/admin.sh >> /salt-openvas-log/admin_install_out.log 2>&1
        - order: 180

Services:
    cmd.run:
        - name: /srv/salt/gvm/scripts/services.sh >> /salt-openvas-log/services_install_out.log 2>&1
        - order: 190