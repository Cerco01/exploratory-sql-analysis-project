-- PLEASE READ THIS BEFORE RUNNING THE EXERCISE;

-- ⚠️ IMPORTANT: This SQL file may crash due to two common issues: comments and missing semicolons.;

-- Suggestions:
-- 1) Always end each SQL query with a semicolon
-- 2) Ensure comments are well-formed:
--    - Use -- for single-line comments only
--    - Avoid inline comments after queries
--    - Do not use multi-line comments, as they may break execution;

-- -----------------------------------------------
-- queries.sql
-- Complete each mission by writing your SQL query
-- directly below the corresponding instruction
-- -----------------------------------------------

-- -----------------------------------------------
-- NOTA PARA CESAR — Correcciones aplicadas al app.py original
--
-- Como siempre, no he podido aguantar y me he metido a investigar por qué daba error el código.
-- Para mí cada error es una oportunidad para aprender y practicar de cara al mundo laboral.
-- Estamos aquí para eso, no?
--
-- Durante el ejercicio he encontrado dos bugs en app.py. Al acabar los ejercicios
-- los he corregido y documentado para que los cursos siguientes no pasen
-- por lo mismo. Espero que os ahorren algún dolor de cabeza. Un abrazo!
--
-- FIX 1 — Encoding UTF-8:
-- Al ejecutar app.py en Windows aparecía el error:
-- charmap codec error: cannot decode byte 0x8f
-- Causa: open() usaba el encoding por defecto del sistema operativo (cp1252 en Windows).
-- Solución: añadir encoding='utf-8' explícitamente en la llamada a open().
--
-- FIX 2 — Soporte para sentencias DML (INSERT, UPDATE, DELETE):
-- pd.read_sql() lanzaba el error:
-- "This result object does not return rows. It has been closed automatically."
-- Causa: pd.read_sql() solo maneja SELECT, no sentencias que no devuelven filas.
-- Solución: detectar el tipo de sentencia en app.py y redirigir DML a engine.begin()
-- con sqlalchemy.text(), que gestiona transacciones correctamente.
-- -----------------------------------------------;

SELECT * FROM regions;
SELECT * FROM species;
SELECT * FROM climate;
SELECT * FROM observations;


-- MISSION 1: Primeras 10 observaciones usando LIMIT;
SELECT * FROM observations LIMIT 10;


-- MISSION 2: Regiones únicas con DISTINCT para evitar duplicados;
SELECT DISTINCT region_id FROM observations;


-- MISSION 3: Total de especies distintas combinando COUNT y DISTINCT;
SELECT COUNT(DISTINCT species_id) FROM observations;


-- MISSION 4: Observaciones filtradas por region_id con WHERE;
SELECT COUNT(*) FROM observations WHERE region_id = 2;


-- MISSION 5: Observaciones en una fecha exacta filtrando con WHERE;
SELECT COUNT(*) FROM observations WHERE observation_date = '1998-08-08';


-- MISSION 6: Region con mas observaciones agrupando y ordenando de mayor a menor;
SELECT region_id, COUNT(*) AS total
FROM observations
GROUP BY region_id
ORDER BY total DESC
LIMIT 1;


-- MISSION 7: Top 5 especies mas frecuentes usando GROUP BY y ORDER BY;
SELECT species_id, COUNT(*) AS total
FROM observations
GROUP BY species_id
ORDER BY total DESC
LIMIT 5;


-- MISSION 8: Especies con menos de 5 registros usando HAVING para filtrar grupos;
SELECT species_id, COUNT(*) AS total
FROM observations
GROUP BY species_id
HAVING total < 5;


-- MISSION 9: Ranking de observadores por numero de registros;
SELECT observer, COUNT(*) AS total
FROM observations
GROUP BY observer
ORDER BY total DESC;


-- MISSION 10: JOIN con regions para mostrar el nombre de region en vez del id;
SELECT o.id, o.observation_date, r.name AS region_name, r.country
FROM observations o
JOIN regions r ON o.region_id = r.id;


-- MISSION 11: JOIN con species para mostrar el nombre cientifico en vez del id;
SELECT o.id, o.observation_date, s.scientific_name, s.common_name
FROM observations o
JOIN species s ON o.species_id = s.id;


-- MISSION 12: Dos JOINs encadenados para ver que especie domina en cada region;
SELECT r.name AS region_name, s.scientific_name, COUNT(*) AS total
FROM observations o
JOIN regions r ON o.region_id = r.id
JOIN species s ON o.species_id = s.id
GROUP BY o.region_id, o.species_id
ORDER BY o.region_id, total DESC;


-- MISSION 13: INSERT de una observacion ficticia para probar escritura en la BD;
INSERT INTO observations (species_id, region_id, observer, observation_date, latitude, longitude, count)
VALUES (1, 1, 'obsr_test_axel', '2026-04-01', -16.5, 145.7, 3);


-- MISSION 14: Busco el registro con error y lo corrijo con UPDATE por id;
SELECT id, scientific_name FROM species WHERE scientific_name LIKE '%Cacatu%';
UPDATE species SET scientific_name = 'Cacatua galerita' WHERE id = 1;


-- MISSION 15: Busco el id de la observacion de prueba y la elimino con DELETE por observer;
SELECT id FROM observations WHERE observer = 'obsr_test_axel';
DELETE FROM observations WHERE observer = 'obsr_test_axel';
