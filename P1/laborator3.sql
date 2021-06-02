use laborator1

select * from Turneu

insert into Turneu (dataStart, dataStop, nume, premiu) values 
('2020-04-12', '2020-04-17', 'Fed Cup', 5000),
('2020-05-19', '2020-05-26', null, 15000),
('2020-08-12', '2020-08-17', 'Wimbledon', 15000),
('2020-01-19', '2020-01-26', 'Fed Cup', 75433)
SELECT * FROM Arbitrii_Meci
SELECT * FROM Arbitru
SELECT * FROM Meci
SELECT * FROM Jucator

insert into Arbitrii_Meci(IDA, IDM) values
(8, 17), (4, 17), (7, 20), (8, 22), (5, 20), (6, 22)

ALTER TABLE Jucator
	ADD [tara origine] VARCHAR(50)

UPDATE Jucator
	SET [tara origine] = 'Elvetia' where IDjucator =12
UPDATE Jucator
	SET [tara origine] = 'Spania' where IDjucator =13
UPDATE Jucator
	SET [tara origine] = 'Serbia' where IDjucator =14
UPDATE Jucator
	SET [tara origine] = 'Romania' where IDjucator =15
UPDATE Jucator
	SET [tara origine] = 'Grecia' where IDjucator =18
UPDATE Jucator
	SET [tara origine] = 'Germania' where IDjucator =19

ALTER TABLE Antrenor
	ADD [tara origine] VARCHAR(50)
SELECT * FROM Antrenor

UPDATE Antrenor
	SET [tara origine] ='Romania' where fostJucator=0
UPDATE Antrenor
	SET [tara origine] ='Danemarca' where fostJucator=1
UPDATE Antrenor
	SET [tara origine] ='Polonia' where IDJucator=13


--union/except/intersect
	--selectez toate tarile de provenienta ale jucatorilor si antrenorilor
SELECT [tara origine] from Jucator
	UNION
	SELECT [tara origine] from Antrenor

	--selectez tarile din care provin atat antrenori cat si jucatori
SELECT [tara origine] from Jucator
	intersect
	SELECT [tara origine] from Antrenor

	--selectez tarile din care provin doar antrenori
SELECT [tara origine] from Antrenor
	except
	SELECT [tara origine] from Jucator


--join
	--selectez toate numele jucatorilor care au antrenor, alaturi de numele antrenorilor
SELECT J.nume as [nume jucator], A.nume as [nume antrenor] FROM Jucator J 
	INNER JOIN Antrenor A on J.IDJucator=A.IDJucator

	--selectez toate terenurile acoperite alaturi de tipul de meci care se joaca pe acestea
SELECT T.IDTeren, M.tip from Teren T left JOIN Meci M on M.IDT=T.IDTeren and T.acoperit=0

	--selectez toate turneele, alaturi de jucatorii care au participat la ele
SELECT J.nume, T.nume from Jucator J
	inner join Meci M on M.IDJucator1=J.IDjucator or M.IDJucator2=J.IDjucator
	left join Turneu T on M.IDTurneu=T.IDTurneu
	
	--selectez numele arbitrilor si scorurile meciurilor pe care le-au arbitrat
SELECT A.nume, M.scor from Arbitru A
	inner join Arbitrii_Meci legatura on A.IDArbitru=legatura.IDA
	inner join Meci M on legatura.IDM=M.IDmeci


--group by
	--selectez toate scorurile obtinute
SELECT scor from Meci
	group by scor

	--selectez numele turneului, numarul de aparitii in BD si media premiilor oferite
select nume, count (IDTurneu) as [nr turnee], avg (premiu) as [premiu mediu] from Turneu
	group by nume

	--selectez numele turneelor si suma premiilor oferite la acest turneu, avand suma premiilor mai mica decat 10000$
select nume, sum (premiu) as [suma premii] from Turneu
	group by nume  having sum(premiu)<10000

	--selectez scorul si momentul inceperii meciurilor de tip finala din BD
select  scor, d_start from Meci
	group by scor, tip, d_start having tip='finala'

