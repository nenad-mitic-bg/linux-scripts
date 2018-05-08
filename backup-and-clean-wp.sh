#!/bin/sh

if  [ $# -ne 6 ];then
    cat <<EOF

Makes a MySql database backup, backs up uploaded files, and deletes backups 
older than given amount of days. 

Usage:
    backup-db.sh DB_NAME DB_USER DB_PASSWORD WORDPRESS_PATH BACKUP_DIR_PATH DAYS_RETENTION

Example:
    backup-db.sh mydb root rootpass /home/me/wp-site /home/me/bd-backups 30

EOF
    exit
fi

dbName=$1
dbUser=$2
dbPass=$3
wpPath=$4
backupDir=$5
retentonDays=$6

tarFile=$(date +%Y%m%d-%H%M).tar
dbDumpFile=$(date +%Y%m%d-%H%M).sql

cd $backupDir

# Make archive with database backup
mysqldump -u $dbUser --password="$dbPass" $dbName > $dbDumpFile
tar -cf $tarFile $dbDumpFile
rm $dbDumpFile

# Add WP uploads to archive
find $wpPath/wp-content/uploads -type d -regex "^.*/uploads/[0-9][0-9][0-9][0-9]/.*$" -exec tar -rf $backupDir/$tarFile {} \;

# Compress the tar file
gzip $tarFile

# Delete old backups
find $backupDir -mtime +$retentonDays -exec rm {} \;
