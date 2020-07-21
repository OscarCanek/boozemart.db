create table Events (
    Id                  int not null,
    EventTimeStamp      datetime not null,	
    ClientId	        int not null, -- visitorId
    Event	            varchar(20) not null,
    ProductId	        int not null, -- itemId
    TransactionId       int null,
    constraint pk_Events primary key clustered(Id)
)