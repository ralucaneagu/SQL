create database MesrsulTrenurilor
use MersulTrenurilor

create table TipuriTren(
id_tip int primary key identity,
descriere varchar(30)
)

create table Trenuri(
id_tren int primary key identity,
nume varchar(30),
id_tip int foreign key references TipuriTren(id_tip))

create table Statii(
id_statie int primary key identity,
nume varchar(30)
)

create table Rute(
id_ruta int primary key identity,
nume varchar(30),
id_tren int foreign key references Trenuri(id_tren)
)

create table RuteStatii (
id_ruta int foreign key references Rute(id_ruta),
id_statie int foreign key references Statii(id_statie),
ora_sosire time,
ora_plecare time,
constraint pk_rutestatii primary key (id_ruta,id_statie) )

--2
go
create procedure uspAdaugaTipTren(@descriere varchar(30))
as
begin
	if (not exists (select descriere from TipuriTren where descriere=@descriere))
		insert into TipuriTren (descriere) values (@descriere);
end;
go

exec uspAdaugaTipTren 'regio'
exec uspAdaugaTipTren 'romanesc-lent'
exec uspAdaugaTipTren 'mocanita'
exec uspAdaugaTipTren 'accelerat'
exec uspAdaugaTipTren 'sageata albastra'
exec uspAdaugaTipTren 'romanesc-rapid'
exec uspAdaugaTipTren 'zburator'
exec uspAdaugaTipTren 'tren avion'


go
create procedure uspAdaugaTren(@nume varchar(30), @id_tip int)
as
begin
	 if(exists(select id_tip from TipuriTren where id_tip=@id_tip))
		insert into Trenuri(nume, id_tip) values (@nume, @id_tip)
	else raisError('Acest tip de tren nu exista', 18, 1);
end;
go


select * from TipuriTren
exec uspAdaugaTren 'racheta', 2
exec uspAdaugaTren 'subacvatic', 1
exec uspAdaugaTren 'turism', 3
exec uspAdaugaTren 'marfa', 2
exec uspAdaugaTren 'ThomasTheTankEngine', 5
exec uspAdaugaTren 'Toby', 5
exec uspAdaugaTren 'aerian', 800

select * from Trenuri

--Cerinta 4 INCEPE AICI
GO
CREATE PROCEDURE uspAdaugaRuta(@numeRuta VARCHAR(30), @id_tren INT)
AS
BEGIN
IF(EXISTS(SELECT id_tren FROM Trenuri WHERE id_tren=@id_tren))
INSERT INTO Rute (nume,id_tren) VALUES (@numeRuta,@id_tren);
ELSE RAISERROR ('Acest tren nu exista', 18,1)
END



GO
EXEC uspAdaugaRuta 'Brasov-Cluj',1;
EXEC uspAdaugaRuta 'Bucuresti-Iasi',7;
EXEC uspAdaugaRuta 'Valcea-Cluj',3;
EXEC uspAdaugaRuta 'Narnia-Bucuresti',2;
EXEC uspAdaugaRuta 'MareaNeagra-Oradea',1;
EXEC uspAdaugaRuta 'America-Luna',6;
EXEC uspAdaugaRuta 'Marte-Soare',9;
EXEC uspAdaugaRuta 'Valcea-Hawaii',5;
EXEC uspAdaugaRuta 'America-Luna',5;



SELECT * FROM Trenuri;
SELECT * FROM Rute

--cerinta5
GO
CREATE PROCEDURE uspAdaugaStatie(
@numeStatie VARCHAR(30)
)
AS
BEGIN
IF(NOT EXISTS(SELECT nume FROM Statii where nume=@numeStatie))
INSERT INTO Statii(nume) VALUES (@numeStatie)
END



GO
SELECT * FROM Rute



GO
EXEC uspAdaugaStatie 'Sighisoara';
EXEC uspAdaugaStatie 'Brasov';
EXEC uspAdaugaStatie 'Cluj';
EXEC uspAdaugaStatie 'Narnia';
EXEC uspAdaugaStatie 'Marte';
EXEC uspAdaugaStatie 'Venus';
EXEC uspAdaugaStatie 'Rai';
EXEC uspAdaugaStatie 'Restanta';
EXEC uspAdaugaStatie 'Pizza hawaii';
EXEC uspAdaugaStatie 'Valcea';
EXEC uspAdaugaStatie 'America';
EXEC uspAdaugaStatie 'MareaNeagra';
EXEC uspAdaugaStatie 'Oradea';
EXEC uspAdaugaStatie 'Luna';
EXEC uspAdaugaStatie 'MareaAlba';

--cerinta6
GO
CREATE PROCEDURE uspAdaugaRuteStatii
(@ruta int,
@statie int,
@os time,
@op time
)
AS
BEGIN
IF(EXISTS(SELECT id_ruta,id_statie FROM RuteStatii WHERE id_ruta=@ruta AND id_statie=@statie))
UPDATE RuteStatii SET ora_sosire=@os, ora_plecare=@op WHERE id_ruta=@ruta AND id_statie=@statie
ELSE
INSERT INTO RuteStatii (id_ruta,id_statie,ora_sosire,ora_plecare) VALUES(@ruta,@statie,@os,@op)
END
GO
SELECT * FROM Rute
SELECT * FROM Statii
EXEC uspAdaugaRuteStatii 1,2,'17:30','17:35'
EXEC uspAdaugaRuteStatii 1,1,'18:30','18:35'
EXEC uspAdaugaRuteStatii 1,3,'19:30','19:35'



EXEC uspAdaugaRuteStatii 2,10,'17:30','17:35'
EXEC uspAdaugaRuteStatii 2,3,'22:30','22:35'



EXEC uspAdaugaRuteStatii 3,4,'12:30','12:35'



EXEC uspAdaugaRuteStatii 4,12,'17:30','17:35'
EXEC uspAdaugaRuteStatii 4,13,'19:30','19:35'



EXEC uspAdaugaRuteStatii 5,11,'17:30','17:35'
EXEC uspAdaugaRuteStatii 5,14,'21:30','21:35'



EXEC uspAdaugaRuteStatii 6,10,'17:30','17:35'
EXEC uspAdaugaRuteStatii 6,9,'19:30','19:35'



EXEC uspAdaugaRuteStatii 7,11,'17:30','17:35'
EXEC uspAdaugaRuteStatii 7,14,'23:30','23:35'




EXEC uspAdaugaRuteStatii 1,2,'20:30','20:40'


--cerinta 7
SELECT * FROM RuteStatii

go
create view vwRuteComplete
as
	select R.nume from Rute R inner join RuteStatii as RS on R.id_ruta=RS.id_ruta
	group by R.id_ruta, R.nume having count (* )=(select count(*) from Statii)

go
select * from vwRuteComplete