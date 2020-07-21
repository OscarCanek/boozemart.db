#!/bin/bash
# Este script encapsula el inicio de los diferentes servicios necesarios para que
# Boozemart funcione.

DBUSER="sa"
DBPWD="Qwer1234"

START=false
STOP=false
SERVICENAME=""
NOWAIT=false #Significa que por defecto va a esperar

MSSQLSERVER=false

# Parse Parameters #
for ARG in $*; do
  case $ARG in
    --start)
      START=true
      ;;
    --stop)
      STOP=true
      ;;
    --nowait)
      NOWAIT=true
      ;;
    --name=*)
      SERVICENAME=${ARG#*=}
      ;;
    *)
      echo "Unknown Argument $ARG" ;;
  esac
done

case "$SERVICENAME" in
"MSSQLServer")
   MSSQLSERVER=true
   ;;
*)
   echo "Unknown service name: $SERVICENAME"
   exit 1
esac

if [ "$START" = true ] && [ "$STOP" = true ]; then
   exit 1
fi

if [ "$START" = false ] && [ "$STOP" = false ]; then
   exit 1
fi

checkSqlIsUp () {
   echo "Wait for complete.."
   status=1
   i=0

   while [ $status -ne 0 ] && [ $i -lt 12 ]; do
      i=$(($i+1))
      echo "Attempt $i for establish a MSSQLServer connection..."
      /opt/mssql-tools/bin/sqlcmd -t 1 -U "$1" -P "$2" -Q "select 1" >> /dev/null
      status=$?
      sleep 10s
   done
   if [ $status -ne 0 ]; then 
      echo "Error: MSSQL SERVER took more than 2 minutes to start up."
      exit 1
   else
      echo "Connection established"
   fi
}

if [ "$MSSQLSERVER" = true ]; then
   echo "Setting up sql server"
   export ACCEPT_EULA="Y"
   export SA_PASSWORD="$DBPWD"
   export MSSQL_PID="Developer"
   /opt/mssql/bin/sqlservr &
   if [ $? -ne 0 ];then
      exit 1
   fi

   if [ "$NOWAIT" = false ] ; then
      checkSqlIsUp "$DBUSER" "$DBPWD"
   fi
fi