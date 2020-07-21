#!/bin/bash
# Este script es una utilidad para el desarollador de este repo

START=false
STOP=false

usage()
{
    echo "Usage: $0 [--start] [--stop] [=?|-h|--help]"
    echo "-?|-h|--help - Shows how to use the command and it's arguments."
    echo "--start - Start Boozemart DB."
    echo "--stop - Stop Boozemart DB"
    exit 1
}

for ARG in $*; do
   case $ARG in
      -\?|-h|--help)
         usage
         exit 1
         ;;  
      --start)
         START=true
         ;;
      --stop)
         STOP=true
         ;;
      *)
         echo "Unknown Argument $ARG" ;;
  esac
done

if [ "$START" = true ]; then
  echo "Staring Boozemart devOS..."
  docker run -d -p 1433:1433 --name dbboozemart boozemartdb:latest
   if [ $? -ne 0 ];then
      exit 1
   fi
fi

if [ "$STOP" = true ]; then
  echo "Stopping Boozemart devOS..."
  docker rm --force dbboozemart
   if [ $? -ne 0 ];then
      exit 1
   fi
fi
