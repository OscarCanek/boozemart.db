alter table Products
    add constraint fk_Products_Brands_Id
    foreign key (BrandId) references Brands(Id)
go

alter table Products
    add constraint fk_Products_Categories_Id
    foreign key (CategoryId) references Categories(Id)
go