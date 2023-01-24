-- zadanie 1
create table dokumenty(
id number(12) primary key,
dokument CLOB);

-- zadanie 2
declare
	counter number := 1;
	mText clob := '';
begin
	loop
    	counter := counter + 1;
    	mText := concat(mText, 'Oto tekst.');
    	if counter > 10000 then
    	exit;
    	end if;
	end loop;
	insert into dokumenty values(1, mText);
end;

-- zadanie 3
select * from dokumenty;
select upper(dokument) from dokumenty;
select length(dokument) from dokumenty;
select DBMS_LOB.getlength(dokument) from dokumenty;
select substr(dokument,1000,5) from dokumenty;
select DBMS_LOB.substr(dokument,100,5) from dokumenty;

-- zadanie 4
insert into dokumenty values(2, '');

-- zadanie 5
insert into dokumenty values(3, null);

-- zadanie 6
select * from dokumenty;

-- zadanie 7
select DIRECTORY_NAME,DIRECTORY_PATH from ALL_DIRECTORIES;

-- zadanie 8
declare
    lob CLOB;
    file BFILE := BFILENAME('ZSBD_DIR', 'dokument.txt');
    doffset integer := 1;
    soffset integer := 1;
    langctx integer := 0;
    warn integer := null;
begin
    select DOKUMENT into lob
    from DOKUMENTY
    where ID = 2
    FOR update;

    dbms_lob.fileopen(file, dbms_lob.file_readonly);
    dbms_lob.loadclobfromfile(lob, file, DBMS_LOB.LOBMAXSIZE, doffset, soffset, 873, langctx, warn);
    dbms_lob.fileclose(file);

    commit;
    DBMS_OUTPUT.PUT_LINE('Status operacji kopiowania: '||warn);
end;

-- zadanie 9
update DOKUMENTY
set DOKUMENT = TO_CLOB(BFILENAME('ZSBD_DIR', 'dokument.txt'), 873)
where ID=3;

-- zadanie 10
select * from DOKUMENTY;

-- zadanie 11
select ID, DBMS_LOB.getlength(DOKUMENT) from DOKUMENTY;

-- zadanie 12
drop table DOKUMENTY;

-- zadanie 13
CREATE OR REPLACE PROCEDURE CLOB_CENSOR (clob1 IN OUT clob, toReplace VARCHAR2)
IS 
position NUMBER;
newText VARCHAR2(100) := '..................................................';
BEGIN
    LOOP
        position := DBMS_LOB.INSTR(clob1, toReplace);
        IF position = 0 THEN
            EXIT;
        END IF;
        DBMS_LOB.WRITE(clob1, length(toReplace), position, newText);
    END LOOP;
END;


-- zadanie 14
CREATE TABLE BIOGRAPHIES_COPIED
AS
SELECT *
FROM ZSBD_TOOLS.BIOGRAPHIES;

SELECT * FROM BIOGRAPHIES_COPIED;

DECLARE
    biog clob;
BEGIN
    SELECT BIO INTO biog FROM BIOGRAPHIES_COPIED
    FOR UPDATE;
    CLOB_CENSOR(biog, 'Cimrman');
    COMMIT;
END;

SELECT * FROM BIOGRAPHIES_COPIED;

-- zadanie 15
DROP TABLE BIOGRAPHIES_COPIED;