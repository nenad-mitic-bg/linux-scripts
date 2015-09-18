#!/bin/sh

if  [ $# -ne 4 ];then
    cat <<EOF

MySql database backup script

Usage:
    backup-db.sh DB_NAME DB_USER DB_PASSWORD BACKUP_DIR_PATH

Example:
    backup-db.sh mydb root rootpass /home/me/bd-backups

EOF
    exit
fi

dbName=$1
dbUser=$2
dbPass=$3
backupDir=$4

outputFile=$(date +%Y%m%d-%H%M).sql

cd $backupDir
mysqldump -u $dbUser --password="$dbPass" $dbName > $outputFile
tar -cvzf $outputFile.tar.gz $outputFile
rm $outputFile
