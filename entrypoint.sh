#!/bin/bash                                                                
# Este script se utiliza como punto de entrada para el contenedor, iniciando los
# servicios requeridos para tener un ambiente de boozemart.
# Además, en este script está un ciclo infinito esperando SIGTERM para terminar, esto
# sirve para que el contenedor no termine de forma anticipada.

cleanup ()
{
  kill -s SIGTERM $!
  exit 0
}

trap cleanup SIGINT SIGTERM

./services.sh --start --name=MSSQLServer
if [ $? -ne 0 ]; then
   exit 1
fi

while [ 1 ]
do
  sleep 60 &
  wait $!
done
