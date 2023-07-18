#! /bin/bash
#Read DB credentials
cd ..
source setenv_runtime_server.txt

GLOBAL_CONFIG_FILE=${REDEYE_HOME}/config/GlobalConfig.properties
instanceName=${INSTANCE_HOME}
instanceName=$(echo ${instanceName##*/})
ENCRYPTION_KEY=`awk -F "=" '$1 ~ /^global.encryption.key$/ {print $2; exit 0;}' $GLOBAL_CONFIG_FILE`
hfExecutionPath=${REDEYE_HOME}/bin/mssqlHF
udmLogFile=${hfExecutionPath}/udmLog.txt
sqlcmdPath=/opt/mssql-tools/bin/sqlcmd
sqlFile=${hfExecutionPath}/udmHF.sql
queryResults=${hfExecutionPath}/QueryResults.txt

if [[ $instanceName -eq "msc" ]]; then
        instanceName=MSC
fi
echo "Working on : "$instanceName

if [[  -e $udmLogFile ]]; then
        rm -f $udmLogFile
fi

echo " " | tee -a $udmLogFile
echo "--------------------------------------------------------------------------------------------" | tee -a $udmLogFile
echo "Start script on "`date` | tee -a $udmLogFile
echo "--------------------------------------------------------------------------------------------" | tee -a $udmLogFile

connectDB(){
        DB_HOST=`awk -F "=" '$1 ~ /^global.mssql.db.host$/ {print $2; exit 0;}' $GLOBAL_CONFIG_FILE`
        DB_USER=`awk -F "=" '$1 ~ /^global.mssql.db.username$/ {print $2; exit 0;}' $GLOBAL_CONFIG_FILE`
        ENCRYPTED_DB_PASSWORD=`awk -F "=" '$1 ~ /^global.mssql.db.password$/ {print $2; exit 0;}' $GLOBAL_CONFIG_FILE`
        DB_PASSWORD=$(${JAVA_HOME}/bin/java -jar ${REDEYE_HOME}/lib/surveilx-encryption-decryption-tool-*.jar com.surveilx.surveilxencryptiondecryptiontool.SurveilxEncryptionDecryptionToolApplication 'decrypt' $ENCRYPTED_DB_PASSWORD $ENCRYPTION_KEY)
        UDM_DB_NAME=`awk -F "=" '$1 ~ /^global.mssql.udm.db.name$/ {print $2; exit 0;}' $GLOBAL_CONFIG_FILE`
}

executeHF(){
        sed -i "s/db_instance/${instanceName}/g" "$sqlFile"
        mssqlResults=`$sqlcmdPath -S $DB_HOST -U $DB_USER -P $DB_PASSWORD -d $UDM_DB_NAME -i $sqlFile -o $queryResults`
        echo "Execution Successful Details in : "${queryResults} | tee -a $udmLogFile
#       mssqlResults=`$sqlcmdPath -S $DB_HOST -U $DB_USER -P $DB_PASSWORD -d $UDM_DB_NAME -i $sqlFile`
#       echo "Execution Successful Details in : "$mssqlResults | tee -a $udmLogFile
}

connectDB
executeHF

echo "--------------------------------------------------------------------------------------------" | tee -a $udmLogFile
echo "End script on "`date` | tee -a $udmLogFile
echo "--------------------------------------------------------------------------------------------" | tee -a $udmLogFile