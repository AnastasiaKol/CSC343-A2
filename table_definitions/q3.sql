-- Participate

SET SEARCH_PATH TO parlgov;
drop table if exists q3 cascade;

-- You must not change this table definition.

create table q3(
        countryName varchar(50),
        year int,
        participationRatio real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
-- DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

DROP VIEW IF EXISTS y1_y2_participation_ratio;
DROP VIEW IF EXISTS annual_participation_ratio;
DROP VIEW IF EXISTS e_participation_ratio;

CREATE VIEW e_participation_ratio AS
SELECT
  id,
  country_id,
  extract(year from e_date) AS year,
  votes_cast,
  electorate,
  votes_cast::decimal/electorate AS e_participation_ratio
FROM election
WHERE
  '01-01-2001' <= e_date AND e_date < '01-01-2017'
  AND votes_cast IS NOT NULL
  AND electorate IS NOT NULL
  -- AND id NOT IN (788,850)
ORDER BY country_id, year;

CREATE VIEW annual_participation_ratio AS
SELECT
  row_number() over (ORDER BY country_id, year) as id,
  country_id,
  year,
  -- sum(e_participation_ratio) AS pr_count,
  -- count(id) AS election_count,
  sum(e_participation_ratio)/count(id) AS annual_pr
FROM e_participation_ratio
GROUP BY
  country_id, year
ORDER BY
  country_id, year;

CREATE VIEW y1_y2_participation_ratio AS
SELECT
  y1.country_id,
  y1.year AS y1,
  y1.annual_pr AS y1_pr,
  y2.year AS y2,
  y2.annual_pr AS y2_pr
FROM annual_participation_ratio y1
JOIN annual_participation_ratio y2
  ON y2.id = y1.id+1
    AND y2.country_id = y1.country_id;

-- the answer to the query
insert into q3 (countryName, year, participationRatio)
SELECT
  name as countryName,
  year,
  annual_pr as participationRatio
FROM annual_participation_ratio pr
JOIN country c ON c.id = pr.country_id
WHERE pr.country_id NOT IN
  ( SELECT DISTINCT country_id
    FROM y1_y2_participation_ratio
    WHERE y1_pr > y2_pr
  )
ORDER BY
  country_id, year;
