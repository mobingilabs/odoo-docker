#!/bin/bash

echo "installing" > /var/log/container_status

set -e

# set odoo database host, port, user and password
: ${PGHOST:=$MOCLOUD_DATABASE_ADDRESS}
: ${PGPORT:=$MOCLOUD_DATABASE_PORT}
: ${PGUSER:=$MOCLOUD_DATABASE_USERNAME}
: ${PGPASSWORD:=$MOCLOUD_DATABASE_PASSWORD}
: ${PGDB:=$MOCLOUD_DATABASE_NAME}
export PGHOST PGPORT PGUSER PGPASSWORD PGDB

echo "db_name = $PGDB" >> /etc/odoo/openerp-server.conf
echo "db_password = $PGPASSWORD" >> /etc/odoo/openerp-server.conf
echo "db_user = $PGUSER" >> /etc/odoo/openerp-server.conf
echo "db_port = $PGPORT" >> /etc/odoo/openerp-server.conf
echo "db_host = $PGHOST" >> /etc/odoo/openerp-server.conf

echo "dbfilter = $PGDB" >> /etc/odoo/openerp-server.conf
echo "debug_mode = False" >> /etc/odoo/openerp-server.conf
echo "list_db = False" >> /etc/odoo/openerp-server.conf
echo "demo = {}" >> /etc/odoo/openerp-server.conf
echo "admin_passwd = $MOCLOUD_DATABASE_PASSWORD" >> /etc/odoo/openerp-server.conf
echo "log_level = debug" >> /etc/odoo/openerp-server.conf

case "$1" in
	--)
		shift
		exec openerp-server "$@"
		;;
	-*)
		exec openerp-server "$@"
		;;
	*)
		exec "$@"
esac

exit 1
