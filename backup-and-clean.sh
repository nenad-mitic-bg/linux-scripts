#!/bin/sh

if  [ $# -ne 4 ];then
    cat <<EOF

Makes a MySql database backup, and deletes backups older than given amount of days.

Usage:
    backup-db.sh DB_NAME DB_USER DB_PASSWORD BACKUP_DIR_PATH DAYS_RETENTION

Example:
    backup-db.sh mydb root rootpass /home/me/bd-backups 30

EOF
    exit
fi

dbName=$1
dbUser=$2
dbPass=$3
backupDir=$4
retentonDays=$5

outputFile=$(date +%Y%m%d-%H%M).sql

cd $backupDir
mysqldump -u $dbUser --password="$dbPass" $dbName > $outputFile
tar -cvzf $outputFile.tar.gz $outputFile
rm $outputFile

find $backupDir -mtime +$retentonDays -exec rm {} \;
