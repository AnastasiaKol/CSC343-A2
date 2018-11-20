-- Left-right

SET SEARCH_PATH TO parlgov;
drop table if exists q4 cascade;

-- You must not change this table definition.


CREATE TABLE q4(
        countryName VARCHAR(50),
        r0_2 INT,
        r2_4 INT,
        r4_6 INT,
        r6_8 INT,
        r8_10 INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
-- DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

DROP VIEW IF EXISTS party_position_histogram;
DROP VIEW IF EXISTS left_right_party_interval;

CREATE VIEW left_right_party_interval AS
SELECT party_id,
  c.name AS countryName,
  left_right,
  CASE WHEN left_right >= 0 AND left_right < 2 THEN 'r0_2'
  WHEN left_right >= 2 AND left_right < 4 THEN 'r2_4'
  WHEN left_right >= 4 AND left_right < 6 THEN 'r4_6'
  WHEN left_right >= 6 AND left_right < 8 THEN 'r6_8'
  WHEN left_right >= 8 AND left_right <= 10 THEN 'r8_10'
  ELSE NULL END AS range
FROM country c
-- LEFT JOIN (SELECT * FROM party WHERE country_id <> 5) p ON c.id = p.country_id
LEFT JOIN party p ON c.id = p.country_id
LEFT JOIN party_position pp ON p.id = pp.party_id
ORDER BY country_id, party_id;


-- the answer to the query
INSERT INTO q4 (countryName, r0_2, r2_4, r4_6, r6_8, r8_10)
SELECT countryName,
  count(CASE WHEN range = 'r0_2' THEN 1 ELSE NULL END) AS r0_2,
  count(CASE WHEN range = 'r2_4' THEN 1 ELSE NULL END) AS r2_4,
  count(CASE WHEN range = 'r4_6' THEN 1 ELSE NULL END) AS r4_6,
  count(CASE WHEN range = 'r6_8' THEN 1 ELSE NULL END) AS r6_8,
  count(CASE WHEN range = 'r8_10' THEN 1 ELSE NULL END) AS r8_10
FROM left_right_party_interval
GROUP BY countryName;
