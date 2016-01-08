until curl localhost
do
	sleep 1
done

echo "Odoo started. Setting up master databases"

curl --data "master_pwd=$MOCLOUD_DATABASE_PASSWORD&name=$MOCLOUD_DATABASE_NAME&lang=en_US&password=$MOCLOUD_DATABASE_PASSWORD" http://192.168.59.103/web/database/create

MOO=`PGPASSWORD=$MOCLOUD_DATABASE_PASSWORD psql -h $MOCLOUD_DATABASE_ADDRESS -U $MOCLOUD_DATABASE_USERNAME -d $MOCLOUD_DATABASE_NAME -c "SELECT password FROM res_users WHERE login='admin';" -t`

if [[ $(echo $MOO |tr '\n' ' ') == " " ]]; then 
	echo "Setting up admin password. Please login as 'admin' and change a password to something only you know"
	PGPASSWORD=$MOCLOUD_DATABASE_PASSWORD psql -h $MOCLOUD_DATABASE_ADDRESS -U $MOCLOUD_DATABASE_USERNAME -d $MOCLOUD_DATABASE_NAME -c "UPDATE res_users SET password='$MOCLOUD_DATABASE_PASSWORD' where login='admin';"
fi; 

echo "Setup completed. Sending signal."

echo "complete" > /var/log/container_status
