sudo apt update -y
apt install -y apache2
/etc/init.d/apache2 start
systemctl enable apache2

timestamp=$(date '+%d%m%Y-%H%M%S')
bucketname=upgrad-sonal
name=sonal
tar -zcvf "/tmp/${name}-httpd-logs-${timestamp}.tar" /var/log/apache2/*.log

aws s3 \
cp /tmp/${name}-httpd-logs-${timestamp}.tar \
s3://${bucketname}/${name}-httpd-logs-${timestamp}.tar
