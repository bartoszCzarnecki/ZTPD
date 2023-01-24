-- zadanie 1
CREATE TABLE MOVIES(
ID NUMBER(12) PRIMARY KEY,
TITLE VARCHAR2(400) NOT NULL,
CATEGORY VARCHAR2(50),
YEAR CHAR(4),
CAST VARCHAR2(4000),
DIRECTOR VARCHAR2(4000),
STORY VARCHAR2(4000),
PRICE NUMBER(5,2),
COVER BLOB,
MIME_TYPE VARCHAR2(50))


-- zadanie 2
INSERT INTO MOVIES
	SELECT descriptions.id, descriptions.title, descriptions.category, trim(descriptions.year), descriptions.cast, descriptions.director, descriptions.story, descriptions.price, covers.IMAGE, covers.MIME_TYPE
        	FROM descriptions full outer join covers on descriptions.id = covers.MOVIE_ID WHERE descriptions.id <67

-- zadanie 3
SELECT ID, TITLE FROM MOVIES WHERE COVER IS NULL;

-- zadanie 4
SELECT ID, TITLE, DBMS_LOB.getlength(COVER) AS FILESIZE FROM MOVIES WHERE COVER IS NOT NULL;

-- zadanie 5
SELECT ID, TITLE, DBMS_LOB.getlength(COVER) AS FILESIZE FROM MOVIES WHERE COVER IS NULL;

-- zadanie 6
SELECT DIRECTORY_NAME, DIRECTORY_PATH FROM ALL_DIRECTORIES;

-- zadanie 7
UPDATE MOVIES
  SET COVER = EMPTY_BLOB(), MIME_TYPE='image/jpeg' WHERE ID = 66;
COMMIT;

-- zadanie 8
SELECT ID, TITLE, DBMS_LOB.getlength(COVER) AS FILESIZE FROM MOVIES WHERE ID IN (65, 66);

-- zadanie 9
DECLARE
    lob BLOB;
    file BFILE := BFILENAME('ZSBD_DIR', 'escape.jpg');
BEGIN
    SELECT COVER INTO lob
    FROM MOVIES
    WHERE ID = 66
    FOR UPDATE;
    dbms_lob.fileopen(file, dbms_lob.file_readonly);
    dbms_lob.loadfromfile(lob, file, dbms_lob.getlength(file));
    dbms_lob.fileclose(file);
    COMMIT;
END;

-- zadanie 10
CREATE TABLE TEMP_COVERS (
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

-- zadanie 11
INSERT INTO TEMP_COVERS VALUES (66, BFILENAME('ZSBD_DIR', 'eagles.jpg'), 'image/jpeg');
COMMIT;

-- zadanie 12
SELECT movie_id, dbms_lob.getlength(image) AS FILESIZE FROM TEMP_COVERS;

-- zadanie 13
DECLARE
    typ VARCHAR2(50);
    lob BLOB;
    file BFILE;
BEGIN
    SELECT image, mime_type INTO file, typ
    FROM TEMP_COVERS;

    dbms_lob.createtemporary(lob, TRUE);

    dbms_lob.fileopen(file, dbms_lob.file_readonly);
    dbms_lob.loadfromfile(lob, file, dbms_lob.getlength(file));
    dbms_lob.fileclose(file);

    UPDATE MOVIES
    SET COVER=lob, MIME_TYPE=typ
    WHERE ID=65;

    COMMIT;

    dbms_lob.freetemporary(lob);
END;

-- zadanie 14
SELECT ID, DBMS_LOB.getlength(COVER) AS FILESIZE
FROM MOVIES
WHERE ID IN (65, 66);

-- zadanie 15
DROP TABLE MOVIES;
DROP TABLE TEMP_COVERS;
