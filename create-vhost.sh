out_dir=$1

if [ -z "$out_dir" ]; then
	out_dir="."
fi

script_title="Create a virtual host"
server_name=""
doc_root_path=""
log_dir_path=""

# pickup server name
dialog --title "Server name (domain)" --backtitle "$script_title" --inputbox "" 8 60 2>/tmp/input.$$

sel=$?

case $sel in
	0)	server_name=`cat /tmp/input.$$` ;;
	*)	clear
		echo Aborted 
		exit ;;
esac



# pickup doc root path
dialog --title "Document root path" --backtitle "$script_title" --inputbox "" 8 60 2>/tmp/input.$$

sel=$?

case $sel in
	0)	doc_root_path=`cat /tmp/input.$$` ;;
	*)	clear
		echo Aborted 
		exit ;;
esac



# pickup log path
dialog --title "Log directory path" --backtitle "$script_title" --inputbox "If not set, defaults to APACHE_LOG_DIR" 8 60 2>/tmp/input.$$

sel=$?

case $sel in
	0)	log_dir_path=`cat /tmp/input.$$` ;;
	*)	clear
		echo Aborted 
		exit ;;
esac

if [ -z "$log_dir_path" ]
then
	log_dir_path='${APACHE_LOG_DIR}'
fi

vhost="<VirtualHost *:80>\n"
vhost="$vhost\tServerName $server_name\n"
vhost="$vhost\tServerAdmin webmaster@localhost\n"
vhost="$vhost\tDocumentRoot $doc_root_path\n\n"
vhost="$vhost\tErrorLog $log_dir_path/error.log\n"
vhost="$vhost\tCustomLog $log_dir_path/access.log combined\n\n"
vhost="$vhost\t<Directory $doc_root_path>\n"
vhost="$vhost\t\tAllowOverride All\n"
vhost="$vhost\t\tRequire all granted\n"
vhost="$vhost\t</Directory>\n"
vhost="$vhost</VirtualHost>"

out_file="$out_dir/$server_name.conf"

if [ -f $out_file ]; then
	rm $out_file
fi

clear
printf "$vhost" >> $out_file
