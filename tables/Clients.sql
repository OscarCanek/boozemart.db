create table Clients (
    Id          int not null,
    FirstName	nvarchar(100) not null,
    LastName	nvarchar(100) not null,
    BirthDate	datetime not null,
    Gender	    varchar(10) not null,
    Company	    varchar(75) not null,
    [Language]	varchar(50) not null,
    Nit	        varchar(20) null,
    Position    varchar(75) null,
    City        varchar(100) not null,
    Email       varchar(100) not null,
    PhoneNumber varchar(20) null,
    constraint pk_Clients primary key clustered(Id)
)
go