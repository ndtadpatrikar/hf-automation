#!/bin/bash

source /opt/actimize/MigrationThresholds/config/config.cfg
cwd=$(pwd)
time_stamp=$(date +%d-%m-%Y-%T)
logFile=$cwd/logs/deployThresholds.log

errorfn()
{
	text=$1
	echo [`date`] : ERROR: $text | tee -a $logFile
	echo "Please refer to "$cwd"/logs/deployThresholds.log"
	exit 2
}

mkdir -p $cwd/logs
mkdir -p $cwd/backup/Thresholds
cd ..

echo "Thresholds deployment started" | tee $logFile


# redefine input variable
v_url="$(echo "$rcm_url" | tr -d '\r')"
v_path_to_rcm="$(echo "$path_to_rcm_utilities" | tr -d '\r')"
overrideTh="Override Thresholds"
defaultTh="Default Thresholds"
activationTh="Activation Thresholds"
internalTh="Internal Thresholds"
internalSettingsConf="Internal Settings Configuration"


################################################################
########### Backup Thresholds from ActOne to CSV ###############
################################################################
## Export individual platform lists
## Put all data in a folder called ActOne_CSV to match the structure we have in RedEye_CSV

cd $cwd
echo >> $logFile
echo "Taking backup of thresholds from ActOne DB to CSV" | tee -a $logFile

echo "Start Exporting thresholds: From List MSC Settings Configuration into CSV: MSC_Settings_Configuration.csv" >> $logFile


	$v_path_to_rcm/export_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC_settingsConfiguration -out="$cwd/backup/Thresholds/MSC Settings Configuration.csv" >> $logFile
	if [ $? -ne 0 ]; then
	errorfn "Failed to export list MSC_settings_Configuration into file MSC_Settings_Configuration.csv"
	fi

echo "Start Exporting thresholds: From List MSC Internal Thresholds into CSV: MSC_Internal_Thresholds.csv" >> $logFile


	$v_path_to_rcm/export_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC_internalThresholds -out="$cwd/backup/Thresholds/MSC Internal Thresholds.csv" >> $logFile
	if [ $? -ne 0 ]; then
	errorfn "Failed to export list MSC_Internal_Thresholds into file MSC_Internal_Thresholds.csv"
	fi

echo "Start Exporting thresholds: From List MSC Internal Settings Configuration into CSV: MSC_Internal_Settings_Configuration.csv" >> $logFile


	$v_path_to_rcm/export_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC_internalSettingsConfiguration -out="$cwd/backup/Thresholds/MSC Internal Settings Configuration.csv" >> $logFile
	if [ $? -ne 0 ]; then
	errorfn "Failed to export list MSC_Internal_Settings_Configuration into file MSC_Internal_Settings_Configuration.csv"
	fi



echo "Start Exporting thresholds: From List MSC Default Thresholds into CSV: MSC_Default_Thresholds.csv" >> $logFile


	$v_path_to_rcm/export_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC Thresholds -out="$cwd/backup/Thresholds/MSC Default Thresholds.csv" >> $logFile
	if [ $? -ne 0 ]; then
	errorfn "Failed to export list MSC_Default_Thresholds into file MSC_Default_Thresholds.csv"
	fi

echo "Start Exporting thresholds: From List MSC Alert Activation Thresholds into CSV: MSC Alert Activation Thresholds.csv" >> $logFile


	$v_path_to_rcm/export_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC General Thresholds -out="$cwd/backup/Thresholds/MSC Alert Activation Thresholds.csv" >> $logFile
	if [ $? -ne 0 ]; then
	errorfn "Failed to export list MSC Alert Activation Thresholds into file MSC Alert Activation Thresholds.csv"
	fi

echo  "Finished taking backup of thresholds from ActOne to CSV files" | tee -a $logFile


###########################################################################
########### Import Thresholds into ActOne  ###############
###########################################################################
# Change the souce of data to pick up from the Delta_CSV folder

cd $cwd/HF4/PlatformLists

echo >> $logFile
echo "Importing thresholds from CSV files to RCM" | tee -a $logFile

file_name="MSC Settings Configuration.csv"

if [[ -f "$file_name" ]]; then
echo "start importing file: MSC Settings Configuration.csv into list: MSC_settingsConfiguration" >> $logFile
	$v_path_to_rcm/import_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC_settingsConfiguration -fileName="MSC Settings Configuration.csv" >> $logFile
	if [ $? -ne 0 ]; then
	errorfn "Failed to import file MSC Settings Configuration.csv into list MSC_settingsConfiguration."
	fi
fi

file_name_1="MSC Internal Settings Configuration.csv"

if [[ -f "$file_name_1" ]]; then
echo "start importing file: MSC Internal Settings Configuration.csv into list: MSC_internalSettingsConfiguration" >> $logFile
	$v_path_to_rcm/import_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC_internalSettingsConfiguration -fileName="MSC Internal Settings Configuration.csv" >> $logFile
	if [ $? -ne 0 ]; then
	errorfn "Failed to import file MSC Internal Settings Configuration.csv into list MSC_internalSettingsConfiguration."
	fi
fi


for file_name in  *.csv; do
	if [[ $file_name == *$overrideTh* ]]; then
		list_id="MSC Override Thresholds"
	elif  [[ $file_name == *$defaultTh* ]]; then
		list_id="MSC Thresholds"
	elif [[ $file_name == *$activationTh* ]]; then
		list_id="MSC General Thresholds"
	elif [[ $file_name == *$internalTh* ]]; then
		list_id="MSC_internalThresholds"
	elif [[ $file_name == *$internalSettingsConf* ]]; then
		list_id="MSC_internalSettingsConfiguration"
	
	
	fi
	
	if [[ $file_name != "MSC Settings Configuration.csv" && $file_name != "MSC Internal Settings Configuration.csv" ]]; then
		echo "start importing file: "$file_name" into list:" $list_id >> $logFile
		$v_path_to_rcm/import_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=$list_id -fileName="$file_name" >> $logFile
		if [ $? -ne 0 ]; then
			echo [`date`] : "ERROR: Failed to import file "$file_name" into list "$list_id"." | tee -a $logFile
			echo "Please refer to "$cwd"/log/deployThresholds.log"
			exit 2
		fi
	fi
	
done

echo >> $logFile
echo "Finished Importing thresholds from CSV files to RCM." | tee -a $logFile
echo "Thresholds deployment finished successfully." | tee -a $logFile
