use laborator1;
--atribute jucator: id(generat automat), nume, pozitie in clasamentul ATP 
--update uri
--stergeri
INSERT INTO Jucator
VALUES ('Roger Federer', 1);
INSERT INTO Jucator
VALUES ('Rafael Nadal', 3);
INSERT INTO Jucator
VALUES ('Djokovic', 4);
INSERT INTO Jucator
VALUES ('Horia Tecau', 12);

SELECT * FROM Jucator

INSERT INTO Jucator
VALUES ('Stefanos Tsitsipas', 5);
INSERT INTO Jucator
VALUES ('Dominic Thiem', 13);
INSERT INTO Jucator
VALUES ('Alex Zverev', 16);
INSERT INTO Jucator
VALUES ('Gael Monfils', 20);

SELECT * FROM Jucator

UPDATE Jucator
SET nume='Abcd' where pozitieClasament>=20

DELETE FROM Jucator
where nume='Rafael Nadal'		--nu se poate sterge inregistrarea, pt ca e legata de o inregistrare din tabelul "Antrenor"

DELETE FROM Jucator
where nume<'D'

--atribute antrenor: id(se genereaza automat), id jucator, nume, data inceperii practicarii, fost jucator(da/ nu)
--update-uri
INSERT INTO Antrenor
VALUES (13, 'Popescu',	'05-20-2000', 0);
INSERT INTO Antrenor
VALUES (13, 'Antrenor1', '01-10-2010', 'true');
INSERT INTO Antrenor
VALUES (18, 'Antrenor2', '08-12-1997', 'false');
INSERT INTO Antrenor
VALUES (15, 'Antrenor3', '01-10-1998', 'true');
INSERT INTO Antrenor
VALUES (18, 'Antrenor4', '05-30-2003', 'false');

SELECT * FROM Antrenor;

UPDATE Antrenor
SET nume='NumeNou' WHERE startExperienta<'01-01-2000'

UPDATE Antrenor
SET startExperienta='05-28-1995' WHERE fostJucator =0 AND IDAntrenor>7


--atribute arbitru: id(generat automat), nume
--stergeri
INSERT INTO Arbitru
VALUES ('Jones');
INSERT INTO Arbitru
VALUES ('Smith');
INSERT INTO Arbitru
VALUES ('Popescu');
INSERT INTO Arbitru
VALUES ('Dupont');
INSERT INTO Arbitru
VALUES ('Lanvin');
INSERT INTO Arbitru
VALUES ('Ramos');
INSERT INTO Arbitru
VALUES ('Murphy');
INSERT INTO Arbitru
VALUES ('Bernardez');
INSERT INTO Arbitru
VALUES ('Nelson');
INSERT INTO Arbitru
VALUES ('Gonzalez');
INSERT INTO Arbitru
VALUES (null);
INSERT INTO Arbitru
VALUES (null);
select * from Arbitru

delete from Arbitru
where IDArbitru <=3 or IDArbitru>=9

delete from Arbitru
where nume is null

update Arbitru
set nume='un nume' where nume is null

--atribute turneu: id, dtaa inceprii, data incheierii, nume, valoare premiu
INSERT INTO Turneu
VALUES ('02-07-2019', '09-07-2019', 'Wimbledon', 5000);
INSERT INTO Turneu
VALUES ('01-09-2019', '09-09-2019', 'Fed Cup', 15000);
INSERT INTO Turneu
VALUES ('06-30-2019', '07-04-2019', 'Bucharest Open', 3400.5);
INSERT INTO Turneu
VALUES ('08-09-2019', '08-15-2019', 'Roland Garros', 5000);
INSERT INTO Turneu
VALUES ('11-09-2019', '11-17-2019', 'Australian Open', 68543);


SELECT * FROM Turneu

delete from Turneu 
WHERE IDTurneu>=11


--creez o tabela cu toate tipurile de suprafete de teren posibile; intre Tipuri_Suprafete si Teren exista o relatie 1-m

/*CREATE TABLE TipuriSuprafete(
id_suprafata int primary key identity,
nume varchar(15)
)*/

INSERT INTO TipuriSuprafete
VALUES ('zgura');
INSERT INTO TipuriSuprafete
VALUES ('hard');
INSERT INTO TipuriSuprafete
VALUES ('iarba');
INSERT INTO TipuriSuprafete
VALUES ('indoor');

delete from TipuriSuprafete where nume=''

INSERT INTO TipuriSuprafete
VALUES (null);

select * from TipuriSuprafete
SELECT id_suprafata FROM TipuriSuprafete where nume is not null

delete from TipuriSuprafete where nume is null




ALTER TABLE Teren
DROP COLUMN suprafara 
ALTER TABLE Teren
ADD tip_suprafata int foreign key references TipuriSuprafete(id_suprafata)

--atribute teren: id, acoperit (da/ nu),  suprafata(tip) [1-4]

INSERT INTO Teren
VALUES ('false', 1)
INSERT INTO Teren
VALUES ('TRUE', 3)
INSERT INTO Teren
VALUES ('false', 2)
INSERT INTO Teren
VALUES ('false', 3)
INSERT INTO Teren
VALUES ('true', 1)
SELECT * FROM Teren

--atribute meci: id, id turneu[7-11], scor, tip, id-uri jucatori[12-15,18-19], id teren[4-8], momentul inceperii, momentul incheierii
INSERT INTO Meci
VALUES (10, '6-3,6-2', 'calificari', 12, 13, 4, '06-30-2019 10:00', '06-30-2019 11:00')
INSERT INTO Meci
VALUES (10, '6-0,6-0', 'calificari', 15, 18, 8, '06-30-2019 12:00', '06-30-2019 12:30')
INSERT INTO Meci
VALUES (8, '6-7,6-2,2-6', 'semifinala', 12, 19, 5, '01-10-2019 10:00', '01-10-2019 11:00')
INSERT INTO Meci
VALUES (10, '6-3,6-2', 'finala', 15, 13, 7, '08-25-2019 10:00', '08-25-2019 11:00')
INSERT INTO Meci
VALUES (8, '6-3,7-6,6-2', 'finala', 12, 13, 4, '06-30-2019 10:00', '06-30-2019 11:00')
SELECT * FROM Meci

--atribute arbitrii-meci: id arbitru[1-8], id meci[16-18,20,23]
--stergeri
INSERT INTO Arbitrii_Meci
VALUES (4, 16)
INSERT INTO Arbitrii_Meci
VALUES (3, 16)
INSERT INTO Arbitrii_Meci
VALUES (5, 17)
INSERT INTO Arbitrii_Meci
VALUES (7, 18)
INSERT INTO Arbitrii_Meci
VALUES (7, 20)
INSERT INTO Arbitrii_Meci
VALUES (6, 23)
INSERT INTO Arbitrii_Meci
VALUES (5, 22)
INSERT INTO Arbitrii_Meci
VALUES (6, 22)
INSERT INTO Arbitrii_Meci
VALUES (5, 18)

SELECT * FROM Arbitrii_Meci

update Arbitrii_Meci
set IDA=5 where IDM=17

delete from Arbitrii_Meci
where IDA>=6


DELETE FROM Arbitrii_Meci
WHERE IDA=2
DELETE FROM Arbitrii_Meci
WHERE IDM>=20 OR IDA =1
DELETE FROM Arbitrii_Meci
WHERE IDM>=20 OR IDA =1

UPDATE Arbitrii_Meci
set IDA=4 where IDA<=4

