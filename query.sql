select * from country;
select * from olympic;
select * from sport;
select * from discipline;
select * from athlete;
select * from result;
select * from participated_in;
select * from consist_of;

-- Query Name: Count Medals by Type for Countries Participating in 2016 Olympics (Both Summer and Winter)
-- Join, Conditional Aggregation, Group By
SELECT country.country_name,
       SUM(CASE WHEN result.medal_type = 'Gold' THEN 1 ELSE 0 END) AS Gold,
       SUM(CASE WHEN result.medal_type = 'Silver' THEN 1 ELSE 0 END) AS Silver,
       SUM(CASE WHEN result.medal_type = 'Bronze' THEN 1 ELSE 0 END) AS Bronze
FROM country 
LEFT JOIN athlete ON country.country_abbrev = athlete.country_abbrev
LEFT JOIN result ON athlete.Athlete_id = result.Athlete_id
LEFT JOIN Olympic ON country.country_abbrev = Olympic.country_abbrev
WHERE (result.Year = 2016 AND result.Season IN ('Summer', 'Winter'))
GROUP BY country.country_name;


-- Query Name: Retrieve Female Athletes from India
-- Simple SELECT query
SELECT * FROM ATHLETE WHERE Gender ='F' AND Country_Abbrev ='IND';

-- Query Name: Retrieve Athletes First Name and Last Name from Ukraine
-- Simple SELECT query
SELECT Fname, Lname
FROM ATHLETE
WHERE Country_Abbrev = 'UKR';

-- Query Name: Retrieve Female Athletes from Thailand Winning Gold Medals in Individual Events
-- NATURAL JOIN, AND Operation
SELECT * FROM ATHLETE NATURAL JOIN RESULT WHERE Type ='Individual' AND Medal_type ='Gold' AND Gender ='F' AND Country_Abbrev='THA';

-- Query Name: Retrieve Sports for the 2016 Summer Olympics
-- JOIN operation
SELECT Sport_name
FROM SPORT
JOIN consist_of ON SPORT.Sport_id = consist_of.Sport_id
WHERE Year = 2016 AND Season = 'Summer';

-- Query Name: Count Medals Won by Country in the 2016 Summer Olympics
-- JOIN operation, Aggregate Function, Group by
SELECT Country_Abbrev, COUNT(Medal_type) as Medal_Count
FROM ATHLETE
JOIN RESULT ON ATHLETE.Athlete_id = RESULT.Athlete_id
WHERE Year = 2016 AND Season = 'Summer'
GROUP BY Country_Abbrev;

-- Query Name: Count Total Medals by Country
-- JOIN operation, Aggregate Function, Group by
SELECT C.Country_name, COUNT(*) AS Total_Medals
FROM RESULT R
JOIN ATHLETE A ON R.Athlete_id = A.Athlete_id
JOIN COUNTRY C ON A.Country_Abbrev = C.Country_Abbrev
GROUP BY C.Country_name;

-- Query Name: Retrieve Athletes Participated in the 2016 Summer Olympics
-- SELECT query with JOIN operation
SELECT A.Fname, A.Lname
FROM PARTICIPATED_IN P
JOIN ATHLETE A ON P.Athlete_id = A.Athlete_id
WHERE P.Year = 2016 AND P.Season = 'Summer';

-- Query Name: Retrieve Countries with Athletes Participated in the 2016 Summer Olympics
-- SELECT query with JOIN operations
SELECT DISTINCT C.Country_name
FROM PARTICIPATED_IN P
JOIN ATHLETE A ON P.Athlete_id = A.Athlete_id
JOIN COUNTRY C ON A.Country_Abbrev = C.Country_Abbrev
WHERE P.Year = 2016 AND P.Season = 'Summer';

-- Query Name: Retrieve Athletes Winning Gold Medals
-- SELECT query with JOIN operation
SELECT A.Fname, A.Lname
FROM RESULT R
JOIN ATHLETE A ON R.Athlete_id = A.Athlete_id
WHERE R.Medal_type = 'Gold';

-- Query Name: Retrieve Results for Wrestling Athletes
-- SELECT query with JOIN operations
SELECT athlete_id, fname, lname, sport_name, discipline_name, medal_type 
FROM result
NATURAL JOIN discipline 
NATURAL JOIN sport 
NATURAL JOIN athlete 
WHERE sport_name = 'Wrestling';

-- Query Name: Count Individual Medals by Country
-- SELECT query with JOIN operations
SELECT country_name, type, COUNT(medal_type) AS medals 
FROM result 
NATURAL JOIN athlete 
NATURAL JOIN country 
WHERE type = 'Individual' 
GROUP BY type, country_name 
ORDER BY medals;

-- Query Name: Count Total Medals by Country in the 2016 Summer Olympics
-- SELECT query with JOIN operations
SELECT C.Country_name, COUNT(*) AS Total_Medals
FROM RESULT R
JOIN ATHLETE A ON R.Athlete_id = A.Athlete_id
JOIN COUNTRY C ON A.Country_Abbrev = C.Country_Abbrev
WHERE R.Year = 2016 AND R.Season = 'Summer'
GROUP BY C.Country_name;

-- Query Name: Count Athletes Participating in Multiple Disciplines
-- SELECT query with JOIN operation
SELECT fname, lname, COUNT(DISTINCT Discipline_name) AS count, sport_id, country_abbrev
FROM athlete 
JOIN result ON athlete.Athlete_id = result.Athlete_id
GROUP BY fname, lname, sport_id, country_abbrev
HAVING COUNT(DISTINCT Discipline_name) > 1
ORDER BY count DESC;


-- Query Name: Count Countries with Participation in Multiple Sports
-- SELECT query with JOIN operations
SELECT country_name, COUNT(DISTINCT discipline.sport_id) AS Total_sports
FROM athlete 
JOIN country ON athlete.country_abbrev = country.country_abbrev
JOIN result ON athlete.Athlete_id = result.Athlete_id
JOIN discipline ON result.Discipline_name = discipline.Discipline_name AND result.Kind = discipline.Kind AND result.Type = discipline.Type
GROUP BY country_name
HAVING COUNT(DISTINCT discipline.sport_id) > 1
ORDER BY Total_sports DESC;


-- Query Name: Calculate Gold and Silver Medal Difference by Country
-- SELECT query with subquery and JOIN operations, SUM, Case
SELECT country_name, go_count, sil_count, ABS(go_count - sil_count) AS difference
FROM
(
  SELECT 
    country_name,
    SUM(CASE WHEN medal_type = 'Gold' THEN 1 ELSE 0 END) AS go_count,
    SUM(CASE WHEN medal_type = 'Silver' THEN 1 ELSE 0 END) AS sil_count
  FROM athlete
  JOIN result ON athlete.Athlete_id = result.Athlete_id
  JOIN country ON athlete.country_abbrev = country.country_abbrev
  WHERE medal_type IN ('Gold', 'Silver')
  GROUP BY country_name
) 
WHERE ABS(go_count - sil_count) >= 2
ORDER BY difference DESC;

-- Query Name: Retrieve Countries with Medal Count Below Average
-- Nested Query, Subquery, Aggregate Function
SELECT country_abbrev, medal_count
FROM
(
  -- Subquery to calculate medal count per country
  SELECT country_abbrev, COUNT(medal_type) AS medal_count
  FROM athlete 
  JOIN result ON athlete.Athlete_id = result.Athlete_id
  GROUP BY country_abbrev
) 
WHERE medal_count < 
(
  -- Subquery to calculate average medal count
  SELECT AVG(medal_count) AS avg_medal_count
  FROM
  (
    -- Subquery to calculate medal count per country
    SELECT country_abbrev, COUNT(medal_type) AS medal_count
    FROM athlete 
    JOIN result ON athlete.Athlete_id = result.Athlete_id
    GROUP BY country_abbrev
  )
)
ORDER BY medal_count ASC;

-- Query Name: Count Gold, Silver, and Bronze Medals by Country
-- Join, Conditional Aggregation, Group By
SELECT country_name,
       SUM(CASE WHEN medal_type = 'Gold' THEN 1 ELSE 0 END) AS Gold,
       SUM(CASE WHEN medal_type = 'Silver' THEN 1 ELSE 0 END) AS Silver,
       SUM(CASE WHEN medal_type = 'Bronze' THEN 1 ELSE 0 END) AS Bronze
FROM athlete 
JOIN result ON athlete.Athlete_id = result.Athlete_id
JOIN country ON athlete.country_abbrev = country.country_abbrev
WHERE medal_type IN ('Gold', 'Silver', 'Bronze')
GROUP BY country_name
-- Filtering out countries without all medal types
HAVING SUM(CASE WHEN medal_type = 'Gold' THEN 1 ELSE 0 END) > 0 
AND SUM(CASE WHEN medal_type = 'Silver' THEN 1 ELSE 0 END) > 0 
AND SUM(CASE WHEN medal_type = 'Bronze' THEN 1 ELSE 0 END) > 0;

-- Query Name: Count Athletes Participating in Multiple Disciplines in Winter Olympics
-- Join, Conditional Count, Group By, Having Clause
SELECT fname, lname, COUNT(DISTINCT Discipline_name) AS count, sport_id, country_abbrev, season
FROM athlete 
JOIN result ON athlete.Athlete_id = result.Athlete_id
-- Filtering for Winter Olympics
WHERE season = 'Winter'
GROUP BY fname, lname, sport_id, country_abbrev, season
-- Filtering out athletes with participation in only one discipline
HAVING COUNT(DISTINCT Discipline_name) > 1
ORDER BY count DESC;

-- Query Name: Count Medals by Type and Total Medals by Country in the 2016 Winter Olympics
-- Join, Conditional Aggregation, Group By
SELECT country_name,
       SUM(CASE WHEN medal_type = 'Gold' THEN 1 ELSE 0 END) AS Gold,
       SUM(CASE WHEN medal_type = 'Silver' THEN 1 ELSE 0 END) AS Silver,
       SUM(CASE WHEN medal_type = 'Bronze' THEN 1 ELSE 0 END) AS Bronze,
       COUNT(medal_type) AS Total
FROM athlete 
JOIN result ON athlete.Athlete_id = result.Athlete_id
JOIN country ON athlete.country_abbrev = country.country_abbrev
WHERE season = 'Winter' AND Year = 2016
GROUP BY country_name
ORDER BY Total DESC;

-- Query Name: Retrieve Athletes' Individual Results with Shared Medals
-- Join, Subquery, IN Operator
SELECT fname, lname, discipline_name, season, type, kind, medal_type
FROM athlete 
JOIN result ON athlete.Athlete_id = result.Athlete_id
WHERE (discipline_name, season, type, kind, medal_type) IN 
(
  -- Subquery to identify shared medals in individual events
  SELECT discipline_name, season, type, kind, medal_type
  FROM result
  WHERE type = 'Individual'
  GROUP BY discipline_name, season, type, kind, medal_type
  HAVING COUNT(DISTINCT Athlete_id) > 1
)
ORDER BY medal_type;

-- Query Name: Count Medals by Type for Countries Participating in 2016 Olympics (Both Summer and Winter)
-- Join, Conditional Aggregation, Group By
SELECT country.country_name,
       SUM(CASE WHEN result.medal_type = 'Gold' THEN 1 ELSE 0 END) AS Gold,
       SUM(CASE WHEN result.medal_type = 'Silver' THEN 1 ELSE 0 END) AS Silver,
       SUM(CASE WHEN result.medal_type = 'Bronze' THEN 1 ELSE 0 END) AS Bronze
FROM country 
LEFT JOIN athlete ON country.country_abbrev = athlete.country_abbrev
LEFT JOIN result ON athlete.Athlete_id = result.Athlete_id
LEFT JOIN Olympic ON country.country_abbrev = Olympic.country_abbrev
WHERE (result.Year = 2016 AND result.Season IN ('Summer', 'Winter'))
GROUP BY country.country_name;