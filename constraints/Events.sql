alter table Events
    add constraint fk_Events_Products_Id
    foreign key (ProductId) references Products(Id)
go

alter table Events
    add constraint fk_Events_Clients_Id
    foreign key (ClientId) references Clients(Id)
go