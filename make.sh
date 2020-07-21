#!/bin/bash

# Parse Parameters #
for ARG in $*; do
  case $ARG in
    --server=*)
      SERVER=${ARG#*=} 
      ;;
    --user=*)
      USER=${ARG#*=} 
      ;;
    --password=*)
      PASSWORD=${ARG#*=} 
      ;;
    --backup=*)
      BACKUP=${ARG#*=} 
      ;;
    --backupdir=*)
      BACKUPDIR=${ARG#*=} 
      ;;
    *)
      echo "Unknown Argument $ARG" ;;
  esac
done

if [ -z "$SERVER" ]; then
  SERVER="(local)"
  echo "SET SERVER TO DEFAULT = $SERVER"
fi

if [ -z "$USER" ]; then
  USER="sa"
  echo "SET USER TO DEFAULT = $USER"
fi

if [ -z "$PASSWORD" ]; then
  echo "SET PASSWORD TO DEFAULT"
  PASSWORD="Qwer1234"
fi

if [ -z "$BACKUP" ]; then
  BACKUP=false
  echo "SET BACKUP TO DEFAULT = $BACKUP"
fi

if [ -z "$BACKUPDIR" ]; then
  BACKUPDIR="$(pwd)/output/"
  echo "SET BACKUPDIR TO DEFAULT = $BACKUPDIR"
fi

if [ ! -f /opt/mssql-tools/bin/sqlcmd ]; then
   echo "SQLCMD is required"
   exit 1
fi

# wait for MSSQL server to start
STATUS=1
i=0

while [ $STATUS -ne 0 ] && [ $i -lt 12 ]; do
   i=$(($i+1))	
   /opt/mssql-tools/bin/sqlcmd -t 1 -r1 -b -m -1 -S $SERVER -U $USER -P $PASSWORD -Q "select 1" >> /dev/null
   STATUS=$?
   sleep 10s
done

if [ $STATUS -ne 0 ]; then 
   echo "Error: MSSQL SERVER took more than 2 minutes to start up."
   exit 1
else
   echo "Connection to $SERVER established"
fi

backup () {
   /opt/mssql-tools/bin/sqlcmd -S $SERVER -U $USER -P $PASSWORD -d master -I -b -Q "BACKUP DATABASE $1 TO DISK='$2/$1.bak'"
   
   EXITCODE=$?
   if [ $EXITCODE -ne 0 ];then
      echo "SQLCMD EXITCODE: $EXITCODE"
      exit 1
   fi
}

compile () {
   for entry in "$1"/*
      do
         if [ $entry = "./triggers/trinszonas_de_beacons.sql" ]; then
            continue
         fi

         echo "$entry"
         RESULT=$(/opt/mssql-tools/bin/sqlcmd -S $SERVER -U $USER -P $PASSWORD -d "$3" -I -b -i "$entry")
         EXITCODE=$?
         if [ $EXITCODE -ne 0 ];then
            echo "$RESULT"
            echo "SQLCMD EXITCODE: $EXITCODE"
            exit 1
         fi
         if [ "$2" = true ] && [ ! -z "$RESULT" ]; then
            echo "$RESULT"
            exit 1
         fi
      done
}

compile "./database" false "master"
if [ $? -ne 0 ];then
   exit 1
fi

# compile "./schemas" false "boozemart"
# if [ $? -ne 0 ];then
#    exit 1
# fi

compile "./tables" false "boozemart"
if [ $? -ne 0 ];then
   exit 1
fi

# compile "./data" false "boozemart"
# if [ $? -ne 0 ];then
#    exit 1
# fi

compile "./constraints" false "boozemart"
if [ $? -ne 0 ];then
   exit 1
fi

# compile "./storedProcedures" false "boozemart"
# if [ $? -ne 0 ];then
#    exit 1
# fi

if [ "$BACKUP" = true ]; then
   backup "boozemart" "$BACKUPDIR"
fi
