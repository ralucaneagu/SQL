use laborator1

/*go
CREATE VIEW vwJucatoriScor
AS 
SELECT J.nume, M.scor FROM Jucator AS J
	INNER JOIN Meci AS M ON M.IDJucator1=J.IDjucator or M.IDJucator2=J.IDjucator



go
select * from vwJucatoriScor

SELECT J.nume, T.nume from Jucator J
	inner join Meci M on M.IDJucator1=J.IDjucator or M.IDJucator2=J.IDjucator
	left join Turneu T on M.IDTurneu=T.IDTurneu

go
CREATE VIEW vwJucatorMeci
AS 
SELECT J.nume  FROM Jucator AS J, COUNT (M.IDMeci) as [numar de meciuri]
	INNER JOIN Meci AS M ON M.IDJucator1=J.IDjucator or M.IDJucator2=J.IDjucator
	
drop view dbo.vwJucatorMeci
drop view dbo.vwJucatoriScor*/

/*go
create table JucatorList(
IDjucator int primary key identity,
nume varchar(40),
pozitieClasament int unique,
dataAdaugare datetime
)

go
ALTER TRIGGER tgInsertJucator
ON dbo.Jucator
FOR INSERT
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO JucatorForTrigger(nume, pozitieClasament)
	SELECT nume, pozitieClasament FROM inserted;
END;

*/


--
--view pentru vizualizarea numelor jucatorilor care au antrenori, alaturi de numele antrenorilor
go
CREATE VIEW vwJucatorAntrenor
AS 
SELECT J.nume as [nume jucator], A.nume as [nume antrenor] FROM Jucator AS J
	INNER JOIN Antrenor as A ON J.IDjucator=A.IDJucator


select * from vwJucatorAntrenor


/*GO
CREATE TABLE AntrenorList(	--tabelul in care se vor salva datele referitoare la modificari asupra tab.Antrenor
dataAd datetime,
tip varchar(20),
tabel varchar(20)
)*/

--trigger pt inserare
GO
alter TRIGGER trigInsertAntrenor
ON Antrenor
FOR INSERT
AS
BEGIN
	--INSERT INTO AntrenorList(dataAd, tip, tabel) SELECT getdate(), 'INSERT', 'ANTRENOR'
	--FROM inserted
	PRINT getdate()
	PRINT 'INSERT'
	PRINT 'ANTRENOR'
END


--
go
insert into Antrenor(IDJucator, nume, startExperienta, fostJucator, [tara origine])
	values (19, 'Daniel', '2019-08-02', 1, 'Islanda')

go
insert into Antrenor(IDJucator, nume, startExperienta, fostJucator, [tara origine])
	values (18, 'Ana', '2019-08-02', 1, 'SUA')

go
insert into Antrenor(IDJucator, nume, startExperienta, fostJucator, [tara origine])
	values (18, 'Ana Maria', '2019-08-02', 1, 'Australia')

go
insert into Antrenor(IDJucator, nume, startExperienta, fostJucator, [tara origine])
	values (19, 'Andrei', '2019-08-02', 1, 'Letonia')

--de adaugat
go
insert into Antrenor(IDJucator, nume, startExperienta, fostJucator, [tara origine])
	values (34, 'Raluca', '2020-01-27', 0, 'Romania')


select * from Antrenor
select * from Jucator

--trigger pt stergere
GO
CREATE TRIGGER trigDeleteAntrenor
ON Antrenor
FOR DELETE
AS
BEGIN
	PRINT getdate()
	PRINT 'DELETE'
	PRINT 'ANTRENOR'
END

delete from Antrenor where startExperienta='2019-08-02'
delete from Antrenor where [tara origine]='Danemarca'
--de sters
delete from Antrenor where IDJucator=19


