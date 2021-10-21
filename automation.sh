sudo apt update -y
apt install -y apache2
/etc/init.d/apache2 start
systemctl enable apache2

if [[ ! -e /etc/cron.d/automation ]]; then
        echo "0 15 * * * /root/Automation_Project/automation.sh > /dev/null" > /etc/cron.d/automation
fi

timestamp=$(date '+%d%m%Y-%H%M%S')
bucketname=upgrad-sonal
name=sonal
tar -zcvf "/tmp/${name}-httpd-logs-${timestamp}.tar" /var/log/apache2/*.log

aws s3 \
cp /tmp/${name}-httpd-logs-${timestamp}.tar \
s3://${bucketname}/${name}-httpd-logs-${timestamp}.tar

size=$(ls -l /tmp/${name}-httpd-logs-${timestamp}.tar --block-size=K | awk '{print $5}')
filename=$(ls -l /tmp/${name}-httpd-logs-${timestamp}* | awk '{print $NF}')
filetype=$(echo "${filename#*.}")
if [[ ! -e /var/www/html/inventory.html ]]; then
        echo "Log Type          Time Created            Type            Size" >> /var/www/html/inventory.html
fi

echo "httpd-logs                ${timestamp}            ${filetype}             ${size}" >> /var/www/html/inventory.html

