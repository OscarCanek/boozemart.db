create table Products (
    Id          int not null,
    CategoryId	int not null,
    [Name]      nvarchar(100) not null,
    BrandId     int not null,
    Volumn      numeric(9,2)	,
    Price       numeric(9,2),
    constraint pk_Products primary key clustered(Id)
)
go