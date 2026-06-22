-- ============================================================
-- Premier League Analytics Project
-- File: 06_dashboard_queries.sql
---------------------------------

-- Purpose:
-- Create dashboard-ready queries for reporting
-- and visualization tools such as Power BI/Tableau.
-- ============================================================

USE premier_league_analytics;

-- ============================================================
-- KPI Summary
-- Used for dashboard headline metrics
-- ============================================================

SELECT
COUNT(*) AS total_matches,
SUM(total_goals) AS total_goals,
ROUND(AVG(total_goals),2) AS avg_goals_per_match,
SUM(total_corners) AS total_corners,
SUM(total_red_cards) AS total_red_cards
FROM match_features;

-- ============================================================
-- League Standings Dashboard
-- Used for overall league ranking visualization
-- ============================================================

SELECT *
FROM vw_league_standings
ORDER BY position;

-- ============================================================
-- Match Results Overview
-- Used for win/draw/loss distribution chart
-- ============================================================

SELECT

CASE
    WHEN home_points = 3 THEN 'Home Win'
    WHEN away_points = 3 THEN 'Away Win'
    ELSE 'Draw'
END AS result,

COUNT(*) AS matches

FROM match_features

GROUP BY result;

-- ============================================================
-- Home Advantage Dashboard
-- Used to compare home vs away performance
-- ============================================================

SELECT

ROUND(AVG(home_goals),2) AS avg_home_goals,

ROUND(AVG(away_goals),2) AS avg_away_goals,

ROUND(AVG(home_shots),2) AS avg_home_shots,

ROUND(AVG(away_shots),2) AS avg_away_shots,

ROUND(AVG(total_corners),2) AS avg_corners

FROM match_features;

-- ============================================================
-- Team Home vs Away Points
-- Used to analyze team-specific home advantage
-- ============================================================

SELECT
    team,
    SUM(home_points) AS home_points,
    SUM(away_points) AS away_points

FROM
(
    SELECT
        home_team AS team,
        home_points,
        0 AS away_points
    FROM match_features

    UNION ALL

    SELECT
        away_team AS team,
        0 AS home_points,
        away_points
    FROM match_features

) x

GROUP BY team
ORDER BY home_points DESC;

-- ============================================================
-- Team Home vs Away Goals
-- ============================================================

SELECT
    team,
    SUM(home_goals) AS home_goals,
    SUM(away_goals) AS away_goals

FROM
(
    SELECT
        home_team AS team,
        home_goals,
        0 AS away_goals
    FROM match_features

    UNION ALL

    SELECT
        away_team AS team,
        0 AS home_goals,
        away_goals
    FROM match_features

) x

GROUP BY team
ORDER BY home_goals DESC;


-- ============================================================
-- Team Goal Performance
-- Used for team comparison charts
-- ============================================================

SELECT

team,

SUM(goals) AS total_goals

FROM (

SELECT
    home_team AS team,
    home_goals AS goals
FROM match_features

UNION ALL

SELECT
    away_team AS team,
    away_goals AS goals
FROM match_features

) AS team_goals

GROUP BY team

ORDER BY total_goals DESC;

-- ============================================================
-- Shooting Efficiency Ranking
-- Used for attacking efficiency analysis
-- ============================================================

SELECT

home_team AS team,

ROUND(AVG(home_conversion_rate),2)
AS avg_conversion_rate

FROM match_features

GROUP BY home_team

ORDER BY avg_conversion_rate DESC;

-- ============================================================
-- Odds vs Results
-- Used to compare bookmaker expectation
-- with match outcomes
-- ============================================================

SELECT

home_team,

away_team,

avg_home_odds,

full_time_result

FROM matches m

JOIN odds o
ON m.match_id = o.match_id

ORDER BY avg_home_odds;

-- ============================================================
-- Match Intensity
-- Used for discipline and physicality analysis
-- ============================================================

SELECT

home_team,

away_team,

total_fouls,

total_yellow_cards,

total_red_cards,

total_corners

FROM match_features

ORDER BY total_fouls DESC;
