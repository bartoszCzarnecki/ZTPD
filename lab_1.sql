-- zadanie 1
create type samochod as object (
	marka varchar2(20),
	model varchar2(20),
	kilometry number,
	data_produkcji date,
	cena number(10,2))
    
create table samochody of samochod;

insert into samochody values (new samochod('opel', 'astra', '21361', date '1998-01-01', 10000));
insert into samochody values (new samochod('opel', 'insignia', '19360', date '2010-01-01', 30000));
insert into samochody values (new samochod('skoda', 'octavia', '31270', date '2002-01-01', 20000));

select * from samochody

-- zadanie 2
create table wlasciciele (imie varchar2(100), nazwisko varchar2(100), auto samochod);

insert into wlasciciele values ('mariusz', 'marianski', new samochod('opel', 'insignia', '12703', date '2009-01-01', 32000));
insert into wlasciciele values ('damian', 'darkowski', new samochod('opel', 'astra', '12703', date '2000-01-01', 12000));

select * from wlasciciele

-- zadanie 3
describe samochod;

alter type samochod replace as object(
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji date,
    cena number(10,2),
    member function wartosc return number
    );

create or replace type body samochod as
    member function wartosc return number is
    begin
        return power(0.9, extract(year from current_date) - extract(year from data_produkcji)) * cena;
    end wartosc;
end;

select marka, cena, s.wartosc() from samochody s;

-- zadanie 4
alter type samochod add map member function porownanie
return number cascade including table data;

create or replace type body samochod as
    member function wartosc return number is
    begin
        return power(0.9,extract (year from current_date) - extract (year from data_produkcji)) * cena;
    end wartosc;

    map member function porownanie return number is
    begin
        return extract (year from current_date) - extract (year from data_produkcji) + floor(kilometry/10000);
    end porownanie;
end;

select * from samochody s order by value(s);

-- zadanie 5
create type wlasciciel as object
(
    imie varchar2(100),
    nazwisko varchar2(100)
);
create table wlasciciele of wlasciciel;
describe samochod;
alter type samochod add attribute (c_wlasciciel ref wlasciciel) cascade;

alter table samochody add scope for (c_wlasciciel) is wlasciciele;

insert into samochody values (new samochod('opel', 'astra', '21361', date '1998-01-01', 10000, null));
insert into samochody values (new samochod('opel', 'insignia', '19360', date '2010-01-01', 30000, null));
insert into samochody values (new samochod('skoda', 'octavia', '31270', date '2002-01-01', 20000, null));

insert into wlasciciele values
(new wlasciciel('mariusz', 'marianski'));
insert into wlasciciele values
(new wlasciciel('damian', 'darkowski'));

update samochody s
set s.c_wlasciciel = (
    select ref(w) from wlasciciele w
    where w.imie = 'damian');

select * from samochody;

-- zadanie 6
CREATE TYPE t_przedmioty IS VARRAY(10) OF VARCHAR(20);

DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
 moje_przedmioty(1) := 'MATEMATYKA';
 moje_przedmioty.EXTEND(9);
 FOR i IN 2..10 LOOP
    moje_przedmioty(i) := 'PRZEDMIOT_' || i;
 END LOOP;
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 moje_przedmioty.TRIM(2);
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.EXTEND();
 moje_przedmioty(9) := 9;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.DELETE();
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

-- zadanie 7
create type tytul_ksiazki is varray(10) of varchar(20);

declare
 type tytul_ksiazki is varray(10) of varchar2(20);
 ksiazki_1 tytul_ksiazki := tytul_ksiazki('');
begin
 ksiazki_1(1) := 'naszi politiczeskoje zadaczi';
 ksiazki_1.extend(9);
 for i in 2..10 loop
    ksiazki_1(i) := 'tytul_' || i;
 end loop;
 for i in ksiazki_1.first()..ksiazki_1.last() loop
    dbms_output.put_line(ksiazki_1(i));
 end loop;
 ksiazki_1.trim(2);
 for i in ksiazki_1.first()..ksiazki_1.last() loop
    dbms_output.put_line(ksiazki_1(i));
 end loop;

 dbms_output.put_line('Limit: ' || ksiazki_1.limit());
 dbms_output.put_line('Liczba elementow: ' || ksiazki_1.count());
 ksiazki_1.extend();
 ksiazki_1(9) := 9;
 dbms_output.put_line('Limit: ' || ksiazki_1.limit());
 dbms_output.put_line('Liczba elementow: ' || ksiazki_1.count());
 ksiazki_1.delete();
 dbms_output.put_line('Limit: ' || ksiazki_1.limit());
 dbms_output.put_line('Liczba elementow: ' || ksiazki_1.count());
end;

-- zadanie 8
DECLARE
TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
moi_wykladowcy.EXTEND(2);
moi_wykladowcy(1) := 'MORZY';
moi_wykladowcy(2) := 'WOJCIECHOWSKI';
moi_wykladowcy.EXTEND(8);
FOR i IN 3..10 LOOP
moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
END LOOP;
FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
END LOOP;
moi_wykladowcy.TRIM(2);
FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
END LOOP;
moi_wykladowcy.DELETE(5,7);
DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
IF moi_wykladowcy.EXISTS(i) THEN
DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
END IF;
END LOOP;
moi_wykladowcy(5) := 'ZAKRZEWICZ';
moi_wykladowcy(6) := 'KROLIKOWSKI';
moi_wykladowcy(7) := 'KOSZLAJDA';
FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
IF moi_wykladowcy.EXISTS(i) THEN
DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
END IF;
END LOOP;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

-- zadanie 9
create type t_miesiace is table of varchar(20);

declare
 type t_miesiace is table of varchar2(20);
 moje_miesiace t_miesiace := t_miesiace();
begin
 moje_miesiace.extend(12);
 moje_miesiace(1) := 'styczen';
 moje_miesiace(2) := 'luty';
 moje_miesiace(3) := 'marze';
 moje_miesiace(4) := 'kwiecien';
 moje_miesiace(5) := 'maj';
 moje_miesiace(6) := 'czerwiec';
 moje_miesiace(7) := 'lipiec';
 moje_miesiace(8) := 'sierpien';
 moje_miesiace(9) := 'wrzesien';
 moje_miesiace(10) := 'pazdziernik';
 moje_miesiace(11) := 'listopad';
 moje_miesiace(12) := 'grudzien';
 for i in moje_miesiace.first()..moje_miesiace.last() loop
 dbms_output.put_line(moje_miesiace(i));
 end loop;
 moje_miesiace.trim(2);
 for i in moje_miesiace.first()..moje_miesiace.last() loop
 dbms_output.put_line(moje_miesiace(i));
 end loop;
 dbms_output.put_line('limit: ' || moje_miesiace.limit());
 dbms_output.put_line('liczba elementow: ' || moje_miesiace.count());
end;

-- zadanie 10
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
nazwa VARCHAR2(50),
kraj VARCHAR2(30),
jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
numer NUMBER,
egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

-- zadanie 11
create type koszyk_produktow_typ as table of varchar2(20);

create type zakup as object (
    name varchar2(20),
    koszyk_produktow koszyk_produktow_typ
);

create table zakupy of zakup
nested table koszyk_produktow store as tab_koszyk_produktow;

insert into zakupy values
(zakup('weekend', koszyk_produktow_typ('bulki', 'ser', 'mieso')));
insert into zakupy values
(zakup('dla babci', koszyk_produktow_typ('236 cytryn', 'rodzynki')));

select z.name, k.*
from zakupy z, table (z.koszyk_produktow) k;

select k.*
from zakupy z, table (z.koszyk_produktow) k;

select * from table (select z.koszyk_produktow from zakupy z where z.name like 'weekend');

insert into table ( select z.koszyk_produktow from zakupy z where z.name like 'weekend')
values ('piwo');

delete from table ( select k.koszyk_produktow from zakupy z where z.name like 'weekend' ) k
where e.column_value = 'ser';

update table ( select z.koszyk_produktow from zakupy z where z.name like 'weekend') k
set k.column_value = 'pieluszki'
where k.column_value = 'piwo';

-- zadanie 12
CREATE TYPE instrument AS OBJECT (
nazwa VARCHAR2(20),
dzwiek VARCHAR2(20),
MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
CREATE TYPE BODY instrument AS
MEMBER FUNCTION graj RETURN VARCHAR2 IS
BEGIN
RETURN dzwiek;
END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
material VARCHAR2(20),
OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_dety AS
OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
BEGIN
RETURN 'dmucham: '||dzwiek;
END;
MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
BEGIN
RETURN glosnosc||':'||dzwiek;
END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
producent VARCHAR2(20),
OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
BEGIN
RETURN 'stukam w klawisze: '||dzwiek;
END;
END;
/
DECLARE
tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','ping-
ping','steinway');
BEGIN
dbms_output.put_line(tamburyn.graj);
dbms_output.put_line(trabka.graj);
dbms_output.put_line(trabka.graj('glosno'));
dbms_output.put_line(fortepian.graj);
END;

-- zadanie 13
CREATE TYPE istota AS OBJECT (
nazwa VARCHAR2(20),
NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
NOT INSTANTIABLE NOT FINAL;
CREATE TYPE lew UNDER istota (
liczba_nog NUMBER,
OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
CREATE OR REPLACE TYPE BODY lew AS
OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
BEGIN
RETURN 'upolowana ofiara: '||ofiara;
END;
END;
DECLARE
KrolLew lew := lew('LEW',4);
InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

-- zadanie 14
DECLARE
tamburyn instrument;
cymbalki instrument;
trabka instrument_dety;
saksofon instrument_dety;
BEGIN
tamburyn := instrument('tamburyn','brzdek-brzdek');
cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
-- saksofon := instrument('saksofon','tra-taaaa');
-- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

-- zadanie 15
CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa')
);
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','ping-
ping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;

-- zadanie 16
CREATE TABLE PRZEDMIOTY (
NAZWA VARCHAR2(50),
NAUCZYCIEL NUMBER REFERENCES PRACOWNICY(ID_PRAC)
);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',100);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',100);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',110);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',110);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',120);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',120);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',130);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',140);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',140);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',140);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',150);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',150);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',160);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',160);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',170);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',180);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',180);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',190);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',200);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',210);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',220);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',220);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',230);

-- zadanie 17
CREATE TYPE ZESPOL AS OBJECT (
 ID_ZESP NUMBER,
 NAZWA VARCHAR2(50),
 ADRES VARCHAR2(100)
);

-- zadanie 18
CREATE OR REPLACE VIEW ZESPOLY_V OF ZESPOL
WITH OBJECT IDENTIFIER(ID_ZESP)
AS SELECT ID_ZESP, NAZWA, ADRES FROM ZESPOLY;

-- zadanie 19
CREATE TYPE PRZEDMIOTY_TAB AS TABLE OF VARCHAR2(100);
/
CREATE TYPE PRACOWNIK AS OBJECT (
ID_PRAC NUMBER,
NAZWISKO VARCHAR2(30),
ETAT VARCHAR2(20),
ZATRUDNIONY DATE,
PLACA_POD NUMBER(10,2),
MIEJSCE_PRACY REF ZESPOL,
PRZEDMIOTY PRZEDMIOTY_TAB,
MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER
);
/
CREATE OR REPLACE TYPE BODY PRACOWNIK AS
MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER IS
BEGIN
RETURN PRZEDMIOTY.COUNT();
END ILE_PRZEDMIOTOW;
END;

-- zadanie 20
CREATE OR REPLACE VIEW PRACOWNICY_V OF PRACOWNIK
WITH OBJECT IDENTIFIER (ID_PRAC)
AS SELECT ID_PRAC, NAZWISKO, ETAT, ZATRUDNIONY, PLACA_POD,
MAKE_REF(ZESPOLY_V,ID_ZESP),
CAST(MULTISET( SELECT NAZWA FROM PRZEDMIOTY WHERE NAUCZYCIEL=P.ID_PRAC ) AS
PRZEDMIOTY_TAB )
FROM PRACOWNICY P;

-- zadanie 21
SELECT *
FROM PRACOWNICY_V;
SELECT P.NAZWISKO, P.ETAT, P.MIEJSCE_PRACY.NAZWA
FROM PRACOWNICY_V P;
SELECT P.NAZWISKO, P.ILE_PRZEDMIOTOW()
FROM PRACOWNICY_V P;
SELECT *
FROM TABLE( SELECT PRZEDMIOTY FROM PRACOWNICY_V WHERE NAZWISKO='WEGLARZ' );
SELECT NAZWISKO, CURSOR( SELECT PRZEDMIOTY
FROM PRACOWNICY_V
WHERE ID_PRAC=P.ID_PRAC)
FROM PRACOWNICY_V P;

-- zadanie 22
CREATE TABLE PISARZE (
ID_PISARZA NUMBER PRIMARY KEY,
NAZWISKO VARCHAR2(20),
DATA_UR DATE );
CREATE TABLE KSIAZKI (
ID_KSIAZKI NUMBER PRIMARY KEY,
ID_PISARZA NUMBER NOT NULL REFERENCES PISARZE,
TYTUL VARCHAR2(50),
DATA_WYDANIE DATE );
INSERT INTO PISARZE VALUES(10,'SIENKIEWICZ',DATE '1880-01-01');
INSERT INTO PISARZE VALUES(20,'PRUS',DATE '1890-04-12');
INSERT INTO PISARZE VALUES(30,'ZEROMSKI',DATE '1899-09-11');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA
VALUES(10,10,'OGNIEM I MIECZEM',DATE '1990-01-05');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA
VALUES(20,10,'POTOP',DATE '1975-12-09');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA
VALUES(30,10,'PAN WOLODYJOWSKI',DATE '1987-02-15');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA
VALUES(40,20,'FARAON',DATE '1948-01-21');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA
VALUES(50,20,'LALKA',DATE '1994-08-01');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA
VALUES(60,30,'PRZEDWIOSNIE',DATE '1938-02-02');

-- zadanie 23
CREATE TYPE AUTO AS OBJECT (
MARKA VARCHAR2(20),
MODEL VARCHAR2(20),
KILOMETRY NUMBER,
DATA_PRODUKCJI DATE,
CENA NUMBER(10,2),
MEMBER FUNCTION WARTOSC RETURN NUMBER
);
CREATE OR REPLACE TYPE BODY AUTO AS
MEMBER FUNCTION WARTOSC RETURN NUMBER IS
WIEK NUMBER;
WARTOSC NUMBER;
BEGIN
WIEK := ROUND(MONTHS_BETWEEN(SYSDATE,DATA_PRODUKCJI)/12);
WARTOSC := CENA - (WIEK * 0.1 * CENA);
IF (WARTOSC < 0) THEN
WARTOSC := 0;
END IF;
RETURN WARTOSC;
END WARTOSC;
END;
CREATE TABLE AUTA OF AUTO;
INSERT INTO AUTA VALUES (AUTO('FIAT','BRAVA',60000,DATE '1999-11-30',25000));
INSERT INTO AUTA VALUES (AUTO('FORD','MONDEO',80000,DATE '1997-05-10',45000));
INSERT INTO AUTA VALUES (AUTO('MAZDA','323',12000,DATE '2000-09-22',52000));

