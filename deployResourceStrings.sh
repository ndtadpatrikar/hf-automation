#!/bin/bash

source /opt/actimize/MigrationThresholds/config/config.cfg
cwd=$(pwd)
time_stamp=$(date +%d-%m-%Y-%T)
logFile=$cwd/logs/deployResourceStrings.log

errorfn()
{
	text=$1
	echo [`date`] : ERROR: $text | tee -a $logFile
	echo "Please refer to "$cwd"/logs/deployResourceStrings.log"
	exit 2
}

mkdir -p $cwd/logs
rm -rf $cwd/logs/deployResourceStrings.log
mkdir -p $cwd/backup/ResourceStrings
cd ..

echo "Resource Strings deployment started" | tee $logFile


# redefine input variable
v_url="$(echo "$rcm_url" | tr -d '\r')"
v_path_to_rcm="$(echo "$path_to_rcm_utilities" | tr -d '\r')"


################################################################
########### Backup Resource Strings from ActOne to CSV ###############
################################################################

cd $cwd
echo >> $logFile
echo "Taking backup of resource strings  from ActOne to CSV" | tee -a $logFile


	$v_path_to_rcm/export_resource_strings.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -out="$cwd/backup/ResourceStrings/ResourceStringsAll.csv" >> $logFile
	if [ $? -ne 0 ]; then
	errorfn "Failed to export resource strings into file ResourceStringsAll.csv"
	fi

echo  "Finished taking backup of reource strings from ActOne to CSV file" | tee -a $logFile


###########################################################################
########### Import Resource Strings into ActOne  ###############
###########################################################################

cd $cwd/HF4/ResourceStrings

echo >> $logFile
echo "Started importing reource strings from CSV files to RCM" | tee -a $logFile

file_name="MyResourceString.csv"

for file_name in  *.csv; do
	
	echo "start importing file: "$file_name"">> $logFile
	$v_path_to_rcm/import_resource_strings.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=$list_id -importPolicy=Overwrite -fileName="$file_name" >> $logFile
	if [ $? -ne 0 ]; then
		echo [`date`] : "ERROR: Failed to import reource string file "$file_name"." | tee -a $logFile
		echo "Please refer to "$cwd"/log/deployResourceStrings.log"
		exit 2
	fi

done

echo >> $logFile
echo "Finished Importing reource strings from CSV files to RCM." | tee -a $logFile
echo "Reource strings deployment finished successfully." | tee -a $logFile