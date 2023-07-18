#!/bin/bash
#set -x #echo on
source ./deployment.properties;
customer=/opt/redkite/$deploy_customer;
source $customer/redeye/bin/setenv_runtime_server.txt;
from_HF=$from_HF;
to_HF=$to_HF;
DEPLOY_LOG=logs/deploy.log
sqlcmdPath=/opt/mssql-tools/bin/sqlcmd
exec >logs/deploy-terminal.log 2>&1
logger()
{
    echo $(date +%Y-%m-%d_%H:%M:%S)" $@" >> $DEPLOY_LOG
    echo $(date +%Y-%m-%d_%H:%M:%S)" $@"
}
logger 'starting from HF'$from_HF;
logger 'deploying HF '$to_HF;
declare -A pathMap;


for((i=$from_HF;i<=$to_HF;i++))
do
		echo 'HF'$i;
		#source HF$i/actions.properties;
		declare -A props
		logger 'Loding Property file';
		file=HF$i/actions.properties;
		while IFS='=' read -r key value; do
		   props["$key"]="$value"
		done < $file

			if [ ${props["deploy.action.AnalyticsContainer"]} = true ]
			then
				logger 'Found deploy.action.AnalyticsContainer=true for HF'$i;
				pathMap[AnalyticsContainer]='HF'$i;
			else
				pathMap[AnalyticsContainer]="NA";
			fi
			if [ ${props["deploy.action.ClientAdapter"]} = true ]
			then
				logger 'Found deploy.action.ClientAdapter=true for HF'$i;
				pathMap[ClientAdapter]='HF'$i;
			else
				pathMap[ClientAdapter]="NA";
			fi
			if [ ${props["deploy.action.Persistence"]} = true ]
			then
				logger 'Found deploy.action.Persistence=true for HF'$i;
				pathMap[Persistence]='HF'$i;
			else
				pathMap[Persistence]="NA";
			fi
			if [ ${props["deploy.action.XMPersister"]} = true ]
			then
				logger 'Found deploy.action.XMPersister=true for HF'$i;
				 pathMap[XMPersister]='HF'$i;
			else
				 pathMap[XMPersister]="NA";
			fi
			if [ ${props["deploy.action.RedeyeDBScripts"]} = true ]
			then
				logger 'Found deploy.action.RedeyeDBScripts=true for HF'$i;
				pathMap[RedeyeDBScripts]='HF'$i;
			else
				pathMap[RedeyeDBScripts]="NA";
			fi
			if [ ${props["deploy.action.MsSqlDBScripts"]} = true ]
			then
				logger 'Found deploy.action.MsSqlDBScripts=true for HF'$i;
				pathMap[MsSqlDBScripts]='HF'$i;
			else
				pathMap[MsSqlDBScripts]="NA";
			fi
			if [ ${props["deploy.action.ImportPlatformLists"]} = true ]
                        then
                                logger 'Found deploy.action.ImportPlatformLists=true for HF'$i;
                                pathMap[ImportPlatformLists]='HF'$i;
			else
				 pathMap[ImportPlatformLists]="NA";
                        fi
			if [ ${props["deploy.action.ImportResourceStrings"]} = true ]
                        then
                                logger 'Found deploy.action.ImportResourceStrings=true for HF'$i;
                                pathMap[ImportResourceStrings]='HF'$i;

                        else
				pathMap[ImportResourceStrings]="NA";
                                logger 'Configuration not found';
                        fi
done

logger "Stopping plateform";
$customer/redeye/bin/stop_platform.bash; >> $DEPLOY_LOG;
logger "Creating backups...";
date_time='backup_'$(date +%y-%m-%d_%T);

logger "Creating Backup in Directory backup/"$date_time;
mkdir backup/$date_time;

source /opt/actimize/MigrationThresholds/config/config.cfg
cwd=$(pwd)
# redefine input variable
v_AIS_ServerFolder="$(echo "$AIS_ServerFolder" | tr -d '\r')"
v_AIS_port="$(echo "$AIS_port" | tr -d '\r')"
v_AIS_user="$(echo "$AIS_user" | tr -d '\r')"
v_AIS_password="$(echo "$AIS_password" | tr -d '\r')"
v_url="$(echo "$rcm_url" | tr -d '\r')"
v_path_to_rcm="$(echo "$path_to_rcm_utilities" | tr -d '\r')"
overrideTh="Override Thresholds"
defaultTh="Default Thresholds"
activationTh="Activation Thresholds"
internalTh="Internal Thresholds"
internalSettingsConf="Internal Settings Configuration"
dryRun="$(echo "$isDryRun" | tr -d '\r')"

errorfn()
{
        text=$1
        echo [`date`] : ERROR: $text | tee -a $DEPLOY_LOG
        echo "Please refer to logs/deploy-terminal.log"
        exit 2
}

################################################################
########### Export Thresholds from ActOne to CSV ###############
################################################################
## Export individual platform lists
## Put all data in a folder called ActOne_CSV to match the structure we have in RedEye_CSV

cd $cwd
echo >> $DEPLOY_LOG
echo "Exporting thresholds from ActOne DB to CSV" | tee -a $DEPLOY_LOG

mkdir -p $cwd/backup/ActOne_CSV

echo "Start Exporting thresholds: From List MSC Settings Configuration into CSV: MSC_Settings_Configuration.csv" >> $DEPLOY_LOG


        $v_path_to_rcm/export_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC_settingsConfiguration -out="$cwd/backup/ActOne_CSV/MSC Settings Configuration.csv" >> $DEPLOY_LOG
        if [ $? -ne 0 ]; then
        errorfn "Failed to export list MSC_settings_Configuration into file MSC_Settings_Configuration.csv"
        fi

echo "Start Exporting thresholds: From List MSC Internal Thresholds into CSV: MSC_Internal_Thresholds.csv" >> $DEPLOY_LOG


        $v_path_to_rcm/export_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC_internalThresholds -out="$cwd/backup/ActOne_CSV/MSC Internal Thresholds.csv" >> $DEPLOY_LOG
        if [ $? -ne 0 ]; then
        errorfn "Failed to export list MSC_Internal_Thresholds into file MSC_Internal_Thresholds.csv"
        fi

echo "Start Exporting thresholds: From List MSC Internal Settings Configuration into CSV: MSC_Internal_Settings_Configuration.csv" >> $DEPLOY_LOG


        $v_path_to_rcm/export_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC_internalSettingsConfiguration -out="$cwd/backup/ActOne_CSV/MSC Internal Settings Configuration.csv" >> $DEPLOY_LOG
        if [ $? -ne 0 ]; then
        errorfn "Failed to export list MSC_Internal_Settings_Configuration into file MSC_Internal_Settings_Configuration.csv"
        fi



echo "Start Exporting thresholds: From List MSC Default Thresholds into CSV: MSC_Default_Thresholds.csv" >> $DEPLOY_LOG


        $v_path_to_rcm/export_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC Thresholds -out="$cwd/backup/ActOne_CSV/MSC Default Thresholds.csv" >> $DEPLOY_LOG
        if [ $? -ne 0 ]; then
        errorfn "Failed to export list MSC_Default_Thresholds into file MSC_Default_Thresholds.csv"
        fi

echo "Start Exporting thresholds: From List MSC Alert Activation Thresholds into CSV: MSC Alert Activation Thresholds.csv" >> $DEPLOY_LOG


        $v_path_to_rcm/export_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC General Thresholds -out="$cwd/backup/ActOne_CSV/MSC Alert Activation Thresholds.csv" >> $DEPLOY_LOG
        if [ $? -ne 0 ]; then
        errorfn "Failed to export list MSC Alert Activation Thresholds into file MSC Alert Activation Thresholds.csv"
        fi

echo  "Finished Exporting thresholds from ActOne to CSV files" | tee -a $DEPLOY_LOG

###########################################################################
############### Export Thresholds from RedEye to CSV #####################
###########################################################################

logger "Creating backup of AnalyticsContainer";
cp $customer/redeye/AnalyticsContainer/package/AnalyticsContainer* backup/$date_time/;
logger "Creating backup of ClientAdapterToolkit";
cp $customer/redeye/ClientAdapterToolkit/lib/ClientAdapterToolkit* backup/$date_time/;
cp $customer/redeye/lib/ClientAdapterToolkit* backup/$date_time/;
logger "Creating backup of Persistence";
cp $customer/redeye/PersistenceServer/lib/PersistenceServer* backup/$date_time/;
logger "Creating backup of XMLPersister";
cp $customer/redeye/XMLPersister/lib/XMLPersister* backup/$date_time/;

echo "Deploying jars...";
if [ ${pathMap[AnalyticsContainer]} != "NA" ]
	then
	logger "Deploying AnalyticsContainer jar";
	cp ${pathMap[AnalyticsContainer]}/AnalyticsContainer/AnalyticsContainer* $customer/redeye/AnalyticsContainer/package/;
fi

if [ ${pathMap[ClientAdapter]} != "NA" ]
	then
	logger "Moving ClientAdapter jar to backup to avoid multiple files in lib directory";
	mv $customer/redeye/lib/ClientAdapterToolkit* backup/$date_time/;
	mv $customer/redeye/ClientAdapterToolkit/lib/ClientAdapterToolkit* backup/$date_time/;

        logger "Deploying ClientAdapter jar to ClientAdapterToolkit lib and Redeye lib directory"
	cp ${pathMap[ClientAdapter]}/ClientAdapter/ClientAdapterToolkit* $customer/redeye/ClientAdapterToolkit/lib/;
	cp ${pathMap[ClientAdapter]}/ClientAdapter/ClientAdapterToolkit* $customer/redeye/lib/;
	chmod 755 $customer/redeye/lib/ClientAdapterToolkit*;
fi

if [ ${pathMap[Persistence]} != "NA" ]
	then
	logger "Deploying Persistence jar";
	cp ${pathMap[Persistence]}/Persistence/PersistenceServer* $customer/redeye/PersistenceServer/lib/;
fi

if [ ${pathMap[XMPersister]} != "NA" ]
	then
	logger "Deploying XMLPersister jar";
	cp ${pathMap[XMPersister]}/XMLPersister/XMLPersister-* $customer/redeye/XMLPersister/lib/;
fi
if [ ${pathMap[ImportPlatformLists]} != "NA" ]
        then
        logger "Importing latest PlatformList CSVs";
         if [ -d $cwd/${pathMap[ImportPlatformLists]}/PlatformLists/ ]; then
                cd $cwd/${pathMap[ImportPlatformLists]}/PlatformLists/

                echo >> $DEPLOY_LOG
                echo "Importing thresholds from Delta CSV files to RCM" | tee -a $DEPLOY_LOG

                file_name="MSC Settings Configuration.csv"

                if [[ -f "$file_name" ]]; then
                echo "start importing file: MSC Settings Configuration.csv into list: MSC_settingsConfiguration" >> $DEPLOY_LOG
                        $v_path_to_rcm/import_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC_settingsConfiguration -fileName="MSC Settings Configuration.csv" >> $DEPLOY_LOG
                        if [ $? -ne 0 ]; then
                        errorfn "Failed to import file MSC Settings Configuration.csv into list MSC_settingsConfiguration."
                        fi
                fi

                file_name_1="MSC Internal Settings Configuration.csv"

                if [[ -f "$file_name_1" ]]; then
                echo "start importing file: MSC Internal Settings Configuration.csv into list: MSC_internalSettingsConfiguration" >> $DEPLOY_LOG
                        $v_path_to_rcm/import_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=MSC_internalSettingsConfiguration -fileName="MSC Internal Settings Configuration.csv" >> $DEPLOY_LOG
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
                        echo "start importing file: "$file_name" into list:" $list_id >> $DEPLOY_LOG
                        $v_path_to_rcm/import_platform_list.sh -acm=$v_url -user=$rcm_user -password=$rcm_password -identifier=$list_id -fileName="$file_name" >> $DEPLOY_LOG
                        if [ $? -ne 0 ]; then
                                echo [`date`] : "ERROR: Failed to import file "$file_name" into list "$list_id"." | tee -a $DEPLOY_LOG
                                echo "Please refer to "$cwd"/log/migrationThresholds.log"
                                exit 2
                        fi
                fi

                done
                echo >> $DEPLOY_LOG
                echo "Finished Importing thresholds from Delta CSV files to RCM." | tee -a $DEPLOY_LOG
        fi
fi


logger "Creating dump of alertparametertype table";
mysqldump -u${deploy_db_user} -p${deploy_db_password} -h${deploy_db_host} -P${deploy_db_port}  ${deploy_db_databaseName} alertparametertype > backup/$date_time/alertparametertype.sql

logger "Creating dump of alertparameters table";
mysqldump -u${deploy_db_user} -p${deploy_db_password} -h${deploy_db_host} -P${deploy_db_port}  ${deploy_db_databaseName} alertparameters > backup/$date_time/alertparameters.sql


logger "Running SQL scripts only if its applicable.";
for((i=$from_HF;i<=$to_HF;i++))
do
		echo 'HF'$i;
		dirpath='HF'$i/RedeyeDBScripts;
		for dir in $dirpath/*; do
		logger "Checking file extension for "$dir" And If db Scripts to run";
		if [[ $dir == *sql ]] && [pathMap[RedeyeDBScripts]="NA" ];
		then
			logger "Running SQL scripts for "$dir;
			mysql -u${deploy_db_user} -p${deploy_db_password} -h${deploy_db_host} -P${deploy_db_port}  ${deploy_db_databaseName} -A < $dir;
			mv $dir $dir'executed'
		fi	
        done
done
for((i=$from_HF;i<=$to_HF;i++))
do
		echo 'HF'$i;
		dirpath='HF'$i/MsSqlDBScripts;
		for dir in $dirpath/*; do
		logger "Checking file extension for "$dir" And If db Scripts to run";
		if [ ${pathMap[MsSqlDBScripts]} != "NA" ];
		then
			logger "Running SQL scripts for "$dir;
			sqlFile=HF$i/MsSqlDBScripts/udmHF.sql;
			sed -i "s/db_instance/${deploy_customer}/g" "$sqlFile"
			mssqlResults=`$sqlcmdPath -S ${mssql_db_host} -U ${mssql_db_user} -P ${mssql_db_password} -d $deploy_customer"_UDM" -i $sqlFile`
			mv $dir $dir'executed'
		fi	
		done
done		


logger "Setting run time env...";
source $customer/redeye/bin/setenv_runtime_server.txt;

#echo "Starting Platform";
#$customer/redeye/bin/start_platform.bash sbd cortex persistence client-adapter xmlPersister;
