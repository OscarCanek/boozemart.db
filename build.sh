#!/bin/bash
# Este script es una utilidad para el desarollador de este repo.
# Contrulle la imagen de docker donde corre la base de datos

usage()
{
    echo "Usage: $0 [=?|-h|--help]"
    echo "-?|-h|--help - Shows how to use the command and it's arguments."
    echo "Compiles the docker image of the Boozemart database"
    exit 1
}

echo "Build compiler image..."
docker build --file ./Dockerfile --tag boozemartdb:latest --build-arg CACHEBUST=$(date +%s) .
if [ $? -ne 0 ];then
   exit 1
fi
