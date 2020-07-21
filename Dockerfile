# Imagen base de Debian 9 + .net core + asp.net
FROM microsoft/mssql-server-linux AS runtime

ARG CACHEBUST=1

############
WORKDIR /sources

COPY ./make.sh ./
COPY ./services.sh ./
COPY ./entrypoint.sh ./

# database
COPY ./database ./database

# schemas
COPY ./schemas ./schemas

# data
COPY ./data ./data

# tables
COPY ./tables ./tables

# constraints
COPY ./constraints ./constraints

# stored procedures
COPY ./storedProcedures ./storedProcedures

RUN chmod +x ./make.sh \
    && chmod +x ./services.sh

#Para compilar la db
RUN ./services.sh --start --name=MSSQLServer \
    && ./make.sh

#MSSQL
EXPOSE 1433

USER root
ENTRYPOINT ["sh", "entrypoint.sh"]
