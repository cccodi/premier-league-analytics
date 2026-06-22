-- ============================================================
-- Premier League Analytics Project
-- File: 02_data_cleaning_validation.sql
------------------------------------------------------------

-- Purpose:
-- Clean and prepare imported Premier League data
-- Convert raw fields into analysis-ready format
-- Standardize naming conventions
-- Validate data quality before analysis.
-- ============================================================

USE premier_league_analytics;


/*
====================================================
1. Convert match_date from VARCHAR to DATE

The raw CSV stores dates as:
DD/MM/YYYY

SQL DATE format requires:
YYYY-MM-DD

Example:
15/08/2025 → 2025-08-15

====================================================
*/


ALTER TABLE matches
ADD COLUMN match_date_clean DATE
AFTER match_date;

UPDATE matches
SET match_date_clean =
STR_TO_DATE(match_date, '%d/%m/%Y');

ALTER TABLE matches
DROP COLUMN match_date;

ALTER TABLE matches
CHANGE COLUMN match_date_clean match_date DATE;

/*
====================================================
2. Standardize team names

The source dataset uses shortened team names.
I converted them into consistent official team names
for accurate grouping and reporting.

Examples:
Man City → Manchester City
Man United → Manchester United
Nott'm Forest → Nottingham Forest
Wolves → Wolverhampton Wanderers

====================================================
*/


UPDATE matches
SET home_team =
CASE home_team

WHEN 'Man City' THEN 'Manchester City'
WHEN 'Man United' THEN 'Manchester United'
WHEN 'Nott''m Forest' THEN 'Nottingham Forest'
WHEN 'Wolves' THEN 'Wolverhampton Wanderers'

ELSE home_team

END;



UPDATE matches
SET away_team =
CASE away_team

WHEN 'Man City' THEN 'Manchester City'
WHEN 'Man United' THEN 'Manchester United'
WHEN 'Nott''m Forest' THEN 'Nottingham Forest'
WHEN 'Wolves' THEN 'Wolverhampton Wanderers'

ELSE away_team

END;


/*
====================================================
3. Remove unnecessary spaces

Trim team names to prevent
duplicate categories caused by spacing issues.

====================================================
*/

UPDATE matches
SET
home_team = TRIM(home_team),
away_team = TRIM(away_team);


/*
====================================================
4. Check missing values

I checked imported records for missing values.

The odds table contains 379 records instead of
the expected 380 matches.

After checking the raw dataset, the missing value
was found in the AHh (Asian Handicap Home) column.

The missing record was kept as NULL because no
reliable replacement value was available.

====================================================
*/


-- Check record counts

SELECT COUNT(*) AS total_matches
FROM matches;

SELECT COUNT(*) AS total_statistics_records
FROM match_statistics;

SELECT COUNT(*) AS total_odds_records
FROM odds;

-- ============================================================
-- Missing Value Resolution
-- ============================================================

-- During validation, I found that the odds table contained
-- 379 records instead of the expected 380 records.

-- By comparing the imported data with the source file,
-- I identified that the odds record for the Brighton vs
-- Chelsea match was missing because the AHh value was
-- blank in the original dataset.

-- To maintain alignment between match_id values across
-- all tables, I shifted subsequent odds match_id values
-- and manually inserted the missing record.

SET FOREIGN_KEY_CHECKS = 0;

UPDATE odds
SET match_id =
    CASE
        WHEN odds_id >= 330 THEN odds_id + 1
        ELSE odds_id
    END;

INSERT INTO odds
(
match_id,
avg_home_odds,
avg_draw_odds,
avg_away_odds,
avg_over_25,
avg_under_25,
asian_handicap
)
VALUES
(
330,
2.44,
3.62,
2.66,
1.63,
2.22,
NULL
);

SELECT *
FROM odds
WHERE match_id BETWEEN 325 AND 335
ORDER BY match_id;

SET FOREIGN_KEY_CHECKS = 1;

-- Verify record counts after correction

SELECT COUNT(*) AS odds_count
FROM odds;


/*
====================================================
5. Remove duplicate matches

A Premier League match should only appear once.

Checked using:
match date + home team + away team

====================================================
*/


DELETE m1
FROM matches m1
JOIN matches m2

ON
m1.match_date = m2.match_date
AND m1.home_team = m2.home_team
AND m1.away_team = m2.away_team
AND m1.match_id > m2.match_id;



/*
====================================================
6. Validate match result values

Expected values:

H = Home Win
D = Draw
A = Away Win

====================================================
*/


SELECT DISTINCT full_time_result
FROM matches;



/*
====================================================
7. Validate final record count

Premier League season should contain:
380 matches

====================================================
*/


SELECT COUNT(*) AS total_matches
FROM matches;

SELECT COUNT(*) AS total_statistics_records
FROM match_statistics;

SELECT COUNT(*) AS total_odds_records
FROM odds;



/*
====================================================
8. Validate final team names

Used to confirm that team names were
successfully standardized.

====================================================
*/


SELECT DISTINCT home_team
FROM matches
ORDER BY home_team;



/*
====================================================
9. Final data checks

Confirm cleaned tables before
feature engineering.

====================================================
*/


SELECT *
FROM matches
LIMIT 10;

SELECT *
FROM match_statistics
LIMIT 10;

SELECT *
FROM odds
LIMIT 10;

UPDATE match_statistics
SET match_id = stats_id;