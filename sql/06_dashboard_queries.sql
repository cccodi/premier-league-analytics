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
-- League Standings Table
-- Used for overall league ranking dashboard
-- Includes points, wins, draws, losses,
-- goals scored, goals conceded, and goal difference
-- ============================================================


WITH team_results AS (

    -- Home team performance
    SELECT
        home_team AS team,

        1 AS played,

        CASE
            WHEN home_goals > away_goals THEN 1
            ELSE 0
        END AS wins,

        CASE
            WHEN home_goals = away_goals THEN 1
            ELSE 0
        END AS draws,

        CASE
            WHEN home_goals < away_goals THEN 1
            ELSE 0
        END AS losses,
        
        home_goals AS goals_for,
        away_goals AS goals_against,
        home_points AS points
    FROM match_features

    UNION ALL

    -- Away team performance
    SELECT

        away_team AS team,

        1 AS played,

        CASE
            WHEN away_goals > home_goals THEN 1
            ELSE 0
        END AS wins,

        CASE
            WHEN away_goals = home_goals THEN 1
            ELSE 0
        END AS draws,

        CASE
            WHEN away_goals < home_goals THEN 1
            ELSE 0
        END AS losses,

        away_goals AS goals_for,
        home_goals AS goals_against,
        away_points AS points
    FROM match_features
)

SELECT

ROW_NUMBER() OVER(
    ORDER BY
        SUM(points) DESC,
        SUM(goals_for - goals_against) DESC,
        SUM(goals_for) DESC
) AS position,

team,
SUM(played) AS played,
SUM(wins) AS wins,
SUM(draws) AS draws,
SUM(losses) AS losses,
SUM(goals_for) AS GF,
SUM(goals_against) AS GA,
SUM(goals_for - goals_against) AS GD,
SUM(points) AS points
FROM team_results
GROUP BY team
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
