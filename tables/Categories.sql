create table Categories (
    Id      int not null,
    [Name]  nvarchar(100) not null,
    constraint pk_Categories primary key clustered(Id)
)
go