-- ============================================================
-- Premier League Analytics Project
-- File: 05_views.sql
---------------------

-- Purpose:
-- Create reusable views to support reporting,
-- dashboard development, and further analysis.
-- ============================================================

USE premier_league_analytics;

-- ============================================================
-- View: Match Summary
----------------------

-- Provides key match-level metrics in a single view.
-- ============================================================

CREATE VIEW vw_match_summary AS

SELECT

match_id,
match_date,

home_team,
away_team,

home_goals,
away_goals,

total_goals,
goal_difference,

home_shot_accuracy,
away_shot_accuracy,

over_2_5_goals

FROM match_features;

-- ============================================================
-- View: Home Advantage
-----------------------

-- Supports analysis of home and away performance.
-- ============================================================

CREATE VIEW vw_home_advantage AS

SELECT

match_id,
match_date,

home_team,
away_team,

home_goals,
away_goals,

home_points,
away_points,

home_clean_sheet,
away_clean_sheet

FROM match_features;


-- ============================================================
-- View: League Standings
------------------------

-- Creates a reusable league table view
-- for dashboard reporting.
-- ============================================================

CREATE VIEW vw_league_standings AS

WITH team_results AS (

    -- Home team results
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


    -- Away team results
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

GROUP BY team;

-- ============================================================
-- View: Shooting Efficiency
----------------------------

-- Supports analysis of shooting accuracy and
-- goal conversion performance.
-- ============================================================

CREATE VIEW vw_shooting_efficiency AS

SELECT

match_id,
match_date,

home_team,
away_team,

home_shots,
away_shots,

home_shots_target,
away_shots_target,

home_shot_accuracy,
away_shot_accuracy,

home_conversion_rate,
away_conversion_rate

FROM match_features;

-- ============================================================
-- View: Match Intensity
------------------------

-- Supports analysis of corners, fouls,
-- and disciplinary records.
-- ============================================================

CREATE VIEW vw_match_intensity AS

SELECT

match_id,
match_date,

home_team,
away_team,

total_corners,
corner_difference,

total_fouls,

total_yellow_cards,
total_red_cards,

red_card_match

FROM match_features;

-- ============================================================
-- Verify view creation
-- ============================================================

SHOW FULL TABLES
WHERE Table_type = 'VIEW';
