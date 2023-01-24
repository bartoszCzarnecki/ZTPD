-- zadanie 1
-- a
CREATE TABLE A6_LRS (GEOM SDO_GEOMETRY);

-- b
INSERT INTO A6_LRS SELECT R.GEOM
FROM STREETS_AND_RAILROADS R, (SELECT * FROM MAJOR_CITIES WHERE CITY_NAME LIKE 'Koszalin') C 
WHERE SDO_WITHIN_DISTANCE(R.GEOM, C.GEOM, 'distance=10 unit=km') = 'TRUE';

-- c
SELECT SDO_GEOM.SDO_LENGTH(GEOM, 1, 'unit=km') DISTANCE, ST_LINESTRING(GEOM).ST_NUMPOINTS() ST_NUMPOINTS FROM A6_LRS;

-- d
UPDATE A6_LRS SET GEOM = SDO_LRS.CONVERT_TO_LRS_GEOM(GEOM, 0,  276.681);

-- e
INSERT INTO USER_SDO_GEOM_METADATA
VALUES ('A6_LRS', 'GEOM', MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', 12.603676, 26.369824, 1), 
        MDSYS.SDO_DIM_ELEMENT('Y', 45.8464, 58.0213, 1), MDSYS.SDO_DIM_ELEMENT('M', 0, 300, 1) ), 8307);

-- f
CREATE INDEX A6_LRS_IDX on A6_LRS(GEOM) INDEXTYPE IS MDSYS.SPATIAL_INDEX;

-- zadanie 2
-- a
SELECT SDO_LRS.VALID_MEASURE(GEOM, 500) VALID_500 FROM A6_LRS;

-- b
SELECT SDO_LRS.LOCATE_PT(GEOM, 276, 0) END_PT FROM A6_LRS;

-- c
SELECT SDO_LRS.LOCATE_PT(GEOM, 150, 0) KM150 FROM A6_LRS;


-- d
SELECT SDO_LRS.CLIP_GEOM_SEGMENT(GEOM, 120, 160) FROM A6_LRS;

-- e
SELECT SDO_UTIL.TO_WKTGEOMETRY(SDO_LRS.GET_NEXT_SHAPE_PT(A6.GEOM, SDO_LRS.PROJECT_PT(A6.GEOM, C.GEOM))) WJAZD
FROM A6_LRS A6, MAJOR_CITIES C WHERE C.CITY_NAME = 'Slupsk';

-- f
SELECT SDO_LRS.OFFSET_GEOM_SEGMENT(A6.GEOM, M.DIMINFO, 50, 200, 50, 'unit=m arc_tolerance=0.05') KOSZT
FROM A6_LRS A6, USER_SDO_GEOM_METADATA M WHERE M.TABLE_NAME = 'A6_LRS' and M.COLUMN_NAME = 'GEOM';
