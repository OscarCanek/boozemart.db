create table Brands (
    Id      int not null,
    [Name]  nvarchar(100) not null,
    constraint pk_Brands primary key clustered(Id)
)
go