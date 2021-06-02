use laborator1

go
alter table Arbitru
	add data_nasterii date

select * from Arbitru

go
update Arbitru
	set data_nasterii ='1970-02-20'
delete from Arbitru where nume is null

go
EXEC sp_rename 'Meci.IDT', 'IDTeren';
select * from Meci
select * from Turneu

delete from Turneu where nume is null

GO
CREATE PROCEDURE uspAdaugaJucator
@nume VARCHAR(40),
@pozitieClasament int,
@tara VARCHAR(50)

AS
BEGIN
	INSERT INTO Jucator (nume, pozitieClasament, [tara origine]) VALUES (@nume, @pozitieClasament, @tara)
END

EXEC uspAdaugaJucator 'Andy Murray', 30, 'SUA';
EXEC uspAdaugaJucator 'Ilie Nastase', 37, 'Romania';
EXEC uspAdaugaJucator 'Alexander Zverev', 19, 'Austria';
EXEC uspAdaugaJucator null, 21, 'Austria';
delete from Jucator where IDjucator>=36

select * from Jucator

go
alter table Arbitrii_Meci
add tip_arbitru varchar(15)
select * from Arbitrii_Meci

--insert into Arbitrii_Meci (IDA, IDM, tip_arbitru) values (4, 16, 'scaun')

update Arbitrii_Meci
set tip_arbitru='tusa'

select * from Arbitrii_Meci
print dbo.ufNrArbitriiPerMeci(17)



--inceput lab 5



/*procedura stocata pt adaugarea unei inregistrari in tabelul TipuriSuprafete +
functie pt verificarea daca tipul care se doreste a fi adaugat exista deja*/
GO
CREATE FUNCTION ufNumeExistentSuprafata
(@nume VARCHAR(40))
RETURNS BIT AS
BEGIN
	IF (EXISTS (SELECT nume from TipuriSuprafete WHERE nume = @nume))
		RETURN 1;
	RETURN 0;
END

GO
CREATE PROCEDURE uspAdaugSuprafata
@nume VARCHAR(40)

AS
BEGIN
	IF dbo.ufNumeExistentSuprafata(@nume)=1 RaisError ('Aceasta suprafata exista deja!', 11, 1)
	else
	INSERT INTO TipuriSuprafete (nume) VALUES (@nume)
END


go
exec dbo.uspAdaugSuprafata 'suprafata noua'	--se poate adauga
exec dbo.uspAdaugSuprafata 'zgura'			--nu se poate adauga
exec dbo.uspAdaugaSuprafata 'sfgh'
exec dbo.uspAdaugaSuprafata 'hard'

select * from TipuriSuprafete

/*adaugarea unei inregistrari in tabelul Meci si verificarea daca data de inceput este
anterioara celei de start si intervalul dintre cele doua este realist*/


GO
CREATE FUNCTION ufValidareData
(@data1 DATETIME,
@data2 DATETIME)
RETURNS BIT AS
BEGIN
	IF (@data1<@data2) and (datediff(hour, @data1, @data2)<5)
		RETURN 1;
	RETURN 0;
END


GO
CREATE PROCEDURE uspAdaugaMeci
@IDTurneu int,
@scor VARCHAR(11),
@tip VARCHAR(20),
@IDJucator1 INT,
@IDJucator2 INT,
@IDTeren INT,
@dstart DATETIME,
@dstop DATETIME

AS
BEGIN
	IF dbo.ufValidareData(@dstart, @dstop)=0 RaisError ('Date alese incorect!', 12, 1)
	ELSE
	INSERT INTO Meci (IDTurneu, scor, tip, IDJucator1, IDJucator2, IDTeren, d_start, d_stop)
		VALUES (@IDTurneu, @scor, @tip, @IDJucator1, @IDJucator2, @IDTeren, @dstart, @dstop)
END

select * from Meci


exec dbo.uspAdaugaMeci 20, '7-5,6-0,4-6', 'finala', 30, 19, 5, '2019-08-15 12:00', '2019-08-15 13:20'
exec dbo.uspAdaugaMeci 20, '7-5,6-0,4-6', 'finala', 30, 19, 5, '2019-08-15 12:00', '2019-08-14 13:20'
exec dbo.uspAdaugaMeci 20, '7-5,6-0,4-6', 'finala', 30, 19, 5, '2019-08-15 12:00', '2019-08-15 19:20'
exec dbo.uspAdaugaMeci 20, '6-3,6-2', 'semifinala', 30, 19, 5, '2020-03-03 11:10', '2020-03-03 11:30'
exec dbo.uspAdaugaMeci 20, '6-3,6-2', 'semifinala', 30, 19, 5, '2020-03-03 11:10', '2020-03-03 10:30'


/*adaugarea unei inregistrari in tablelul Arbitru si verificarea daca acesta este major*/

go
CREATE FUNCTION ufValidareVarsta
(@data_nasterii date)
RETURNS BIT AS
BEGIN
	IF (datediff(YEAR, @data_nasterii, GETDATE())<18)
		RETURN 0;
	RETURN 1;
END


go
CREATE PROCEDURE uspAdaugaArbitru
@nume varchar(40),
@data_nasterii date
AS
BEGIN
	IF dbo.ufValidareVarsta(@data_nasterii)=0 RaisError ('Varsta trebuie sa fie minim 18!', 13, 1)
	ELSE INSERT INTO Arbitru (nume, data_nasterii) VALUES (@nume, @data_nasterii)
END

exec dbo.uspAdaugaArbitru'Popescu', '2010-04-27'
exec dbo.uspAdaugaArbitru 'Ionescu', '1979-04-27'
exec dbo.uspAdaugaArbitru null, '2000-04-27'
exec dbo.uspAdaugaArbitru 'Mourier', '1980-07-29'
exec dbo.uspAdaugaArbitru 'Nouni', '1985-01-04'
exec dbo.uspAdaugaArbitru 'Hughes', '1980-07-29'
exec dbo.uspAdaugaArbitru 'Molina', '1985-01-04'
exec dbo.uspAdaugaArbitru 'Ullrich', '1985-01-04'
exec dbo.uspAdaugaArbitru 'Graf', '1980-07-29'
exec dbo.uspAdaugaArbitru 'Garner', '1985-01-04'
exec dbo.uspAdaugaArbitru 'Raluca', '2020-07-09'
exec dbo.uspAdaugaArbitru 'Raluca', '2000-07-09'

select * from Arbitru


/*adaugarea unei inregistrari in tabelul de legatura ArbitriiMeci si verificarea daca numarul de arbitrii
existenti depaseste limita impusa (10)*/
go
CREATE FUNCTION ufNrArbitriiPerMeci 
(@IDmeci int) 
RETURNS INT AS 
BEGIN 
	DECLARE @nr_arbitrii int=0
	SELECT @nr_arbitrii=COUNT(*) FROM Arbitrii_Meci where IDM=@IDmeci
	RETURN @nr_arbitrii
END;

go
CREATE PROCEDURE uspAdaugaArbitriiMeci
@IDarbitru int,
@IDmeci int,
@tip_arbitru varchar(15)
AS
BEGIN
	IF (dbo.ufNrArbitriiPerMeci(@IDmeci)>9)
		raisError('Nu pot exista mai mult de 10 arbitrii la un meci', 13, 1)
	ELSE INSERT INTO Arbitrii_Meci(IDA, IDM, tip_arbitru) values (@IDarbitru, @IDmeci, @tip_arbitru)
END


exec dbo.uspAdaugaArbitriiMeci 25, 17, 'fileu'
exec dbo.uspAdaugaArbitriiMeci 26, 17, 'rezerva'
exec dbo.uspAdaugaArbitriiMeci 27, 17, 'fileu'
exec dbo.uspAdaugaArbitriiMeci 28, 17, 'fileu'
exec dbo.uspAdaugaArbitriiMeci 29, 17, 'fileu'
exec dbo.uspAdaugaArbitriiMeci 30, 17, 'rezerva'
exec dbo.uspAdaugaArbitriiMeci 31, 17, 'rezerva'
exec dbo.uspAdaugaArbitriiMeci 32, 17, 'rezerva' --se depaseste limita pt meciul cu id 17
exec dbo.uspAdaugaArbitriiMeci 32, 16, 'fileu'
exec dbo.uspAdaugaArbitriiMeci 33, 16, 'tusa'
exec dbo.uspAdaugaArbitriiMeci 33, 17, 'tusa'


print dbo.ufNrArbitriiPerMeci(17)

select * from Arbitrii_Meci

/*adaugarea unei nregistrari in tabelul Turneu, verificarea daca datele desfasurarii
sunt valide si daca premiul se incadreaza in intervalul 1.000-11.000.000$*/

go
CREATE FUNCTION ufValidareDataTurneu
(@data1 DATE,
@data2 DATE)
RETURNS BIT AS
BEGIN
	IF (@data1<@data2) and (datediff(day, @data1, @data2)<=14)
		RETURN 1;
	RETURN 0;
END


go
CREATE FUNCTION ufValidarePemiu
(@premiu money)
RETURNS BIT AS
BEGIN
	IF (@premiu>1000) and (@premiu<110000000)
		RETURN 1;
	RETURN 0;
END

go
CREATE PROCEDURE uspAdaugareTurneu
@data_start DATE,
@data_stop DATE,
@nume VARCHAR(50),
@premiu MONEY
AS
BEGIN
	IF(dbo.ufValidareDataTurneu(@data_start, @data_stop)=0)
		raisError('Datele trebuie sa fie valide, iar durata de maximum 14 zile', 13, 1)
	ELSE IF(dbo.ufValidarePemiu(@premiu)=0)
		raisError('Valoarea premiului trebuie sa fie in intervalul 1000-11000000', 13, 1)
	ELSE INSERT INTO Turneu(dataStart, dataStop, nume, premiu) VALUES (@data_start, @data_stop, @nume, @premiu)
END

exec dbo.uspAdaugareTurneu '2020-01-01', '2020-01-10', 'Fed Cup', 2000
exec dbo.uspAdaugareTurneu '2020-01-01', '2020-01-20', 'Australian Open', 200000
exec dbo.uspAdaugareTurneu '2020-01-08', '2020-01-05', 'Australian Open', 200000
exec dbo.uspAdaugareTurneu '2020-05-01', '2020-05-08', 'Australian Open', 200


select *from Turneu
	


