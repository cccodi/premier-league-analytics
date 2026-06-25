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
-- View: League Standings Summary
-- ------------------------------------------------------------
-- Purpose:
-- Creates a reusable league table showing final standings,
-- including wins, draws, losses, goals scored, goals conceded,
-- goal difference, and points.
--
-- Grain:
-- One row per team.
-- ============================================================

CREATE VIEW league_standings_summary AS

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
-- View: League Standings Wide
-- ------------------------------------------------------------
-- Purpose:
-- Creates an expanded standings table with overall, home,
-- away, and half-time performance metrics for each team.
--
-- Grain:
-- One row per team.
--
-- Used In:
-- Team comparison analysis
-- Home vs Away analysis
-- Half-Time performance analysis
-- ============================================================

CREATE VIEW league_standings_wide AS

WITH

-- OVERALL
overall_stats AS (

    SELECT
        team,
        SUM(played) AS played,
        SUM(wins) AS wins,
        SUM(draws) AS draws,
        SUM(losses) AS losses,
        SUM(goals_for) AS gf,
        SUM(goals_against) AS ga,
        SUM(goals_for - goals_against) AS gd,
        SUM(points) AS points

    FROM (

        SELECT
            home_team AS team,
            1 AS played,
            CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END AS wins,
            CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END AS draws,
            CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END AS losses,
            home_goals AS goals_for,
            away_goals AS goals_against,
            home_points AS points
        FROM match_features

        UNION ALL

        SELECT
            away_team AS team,
            1 AS played,
            CASE WHEN away_goals > home_goals THEN 1 ELSE 0 END,
            CASE WHEN away_goals = home_goals THEN 1 ELSE 0 END,
            CASE WHEN away_goals < home_goals THEN 1 ELSE 0 END,
            away_goals,
            home_goals,
            away_points
        FROM match_features

    ) x

    GROUP BY team
),

-- HOME
home_stats AS (

    SELECT
        home_team AS team,

        COUNT(*) AS home_played,

        SUM(CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) AS home_wins,

        SUM(CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END) AS home_draws,

        SUM(CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END) AS home_losses,

        SUM(home_goals) AS home_gf,

        SUM(away_goals) AS home_ga,

        SUM(home_goals - away_goals) AS home_gd,

        SUM(home_points) AS home_points

    FROM match_features

    GROUP BY home_team
),

-- AWAY
away_stats AS (

    SELECT
        away_team AS team,

        COUNT(*) AS away_played,

        SUM(CASE WHEN away_goals > home_goals THEN 1 ELSE 0 END) AS away_wins,

        SUM(CASE WHEN away_goals = home_goals THEN 1 ELSE 0 END) AS away_draws,

        SUM(CASE WHEN away_goals < home_goals THEN 1 ELSE 0 END) AS away_losses,

        SUM(away_goals) AS away_gf,

        SUM(home_goals) AS away_ga,

        SUM(away_goals - home_goals) AS away_gd,

        SUM(away_points) AS away_points

    FROM match_features

    GROUP BY away_team
),

-- HALF-TIME
ht_stats AS (

    SELECT
        team,

        COUNT(*) AS ht_played,

        SUM(ht_win) AS ht_wins,

        SUM(ht_draw) AS ht_draws,

        SUM(ht_loss) AS ht_losses,

        SUM(ht_gf) AS ht_gf,

        SUM(ht_ga) AS ht_ga,

        SUM(ht_gf - ht_ga) AS ht_gd,

        SUM(ht_points) AS ht_points

    FROM (

        SELECT

            home_team AS team,

            CASE WHEN half_home_goals > half_away_goals THEN 1 ELSE 0 END AS ht_win,

            CASE WHEN half_home_goals = half_away_goals THEN 1 ELSE 0 END AS ht_draw,

            CASE WHEN half_home_goals < half_away_goals THEN 1 ELSE 0 END AS ht_loss,

            half_home_goals AS ht_gf,

            half_away_goals AS ht_ga,

            CASE
                WHEN half_home_goals > half_away_goals THEN 3
                WHEN half_home_goals = half_away_goals THEN 1
                ELSE 0
            END AS ht_points

        FROM matches

        UNION ALL

        SELECT

            away_team AS team,

            CASE WHEN half_away_goals > half_home_goals THEN 1 ELSE 0 END,

            CASE WHEN half_away_goals = half_home_goals THEN 1 ELSE 0 END,

            CASE WHEN half_away_goals < half_home_goals THEN 1 ELSE 0 END,

            half_away_goals,

            half_home_goals,

            CASE
                WHEN half_away_goals > half_home_goals THEN 3
                WHEN half_away_goals = half_home_goals THEN 1
                ELSE 0
            END

        FROM matches

    ) y

    GROUP BY team
)

SELECT

    o.*,

    h.home_played,
    h.home_wins,
    h.home_draws,
    h.home_losses,
    h.home_gf,
    h.home_ga,
    h.home_gd,
    h.home_points,

    ROUND(h.home_wins * 100.0 / NULLIF(h.home_played,0),2) AS home_win_pct,

    a.away_played,
    a.away_wins,
    a.away_draws,
    a.away_losses,
    a.away_gf,
    a.away_ga,
    a.away_gd,
    a.away_points,

    ROUND(a.away_wins * 100.0 / NULLIF(a.away_played,0),2) AS away_win_pct,

    ht.ht_played,
    ht.ht_wins,
    ht.ht_draws,
    ht.ht_losses,
    ht.ht_gf,
    ht.ht_ga,
    ht.ht_gd,
    ht.ht_points,

    ROUND(ht.ht_wins * 100.0 / NULLIF(ht.ht_played,0),2) AS ht_win_pct

FROM overall_stats o

LEFT JOIN home_stats h
    ON o.team = h.team

LEFT JOIN away_stats a
    ON o.team = a.team

LEFT JOIN ht_stats ht
    ON o.team = ht.team;


-- ============================================================
-- View: Team Performance Summary
-- ------------------------------------------------------------
-- Purpose:
-- Aggregates attacking, defensive, efficiency, and discipline
-- metrics to identify performance drivers behind team success.
--
-- Grain:
-- One row per team.
--
-- Used In:
-- Dashboard 2 - Performance Drivers
-- ============================================================

CREATE VIEW team_performance_summary AS

WITH team_stats AS (

    -- Home matches
    SELECT
        home_team AS team,

        1 AS matches_played,

        CASE WHEN home_points = 3 THEN 1 ELSE 0 END AS wins,
        CASE WHEN home_points = 1 THEN 1 ELSE 0 END AS draws,
        CASE WHEN home_points = 0 THEN 1 ELSE 0 END AS losses,

        home_points AS points,

        home_goals AS goals_for,
        away_goals AS goals_against,

        home_shots AS shots,
        home_shots_target AS shots_target,

        home_corners AS corners,
        home_fouls AS fouls,

        home_yellow AS yellow_cards,
        home_red AS red_cards,

        CASE WHEN home_clean_sheet = 'Yes' THEN 1 ELSE 0 END AS clean_sheet

    FROM match_features

    UNION ALL

    -- Away matches
    SELECT
        away_team AS team,

        1,

        CASE WHEN away_points = 3 THEN 1 ELSE 0 END,
        CASE WHEN away_points = 1 THEN 1 ELSE 0 END,
        CASE WHEN away_points = 0 THEN 1 ELSE 0 END,

        away_points,

        away_goals,
        home_goals,

        away_shots,
        away_shots_target,

        away_corners,
        away_fouls,

        away_yellow,
        away_red,

        CASE WHEN away_clean_sheet = 'Yes' THEN 1 ELSE 0 END

    FROM match_features
)

SELECT

    team,

    SUM(matches_played) AS matches_played,

    SUM(wins) AS wins,
    SUM(draws) AS draws,
    SUM(losses) AS losses,

    SUM(points) AS points,

    ROUND(
        SUM(points) * 1.0 /
        NULLIF(SUM(matches_played),0),
        2
    ) AS points_per_match,

    SUM(goals_for) AS goals_for,
    SUM(goals_against) AS goals_against,

    SUM(goals_for - goals_against) AS goal_difference,

    ROUND(
        SUM(goals_for) * 1.0 /
        NULLIF(SUM(matches_played),0),
        2
    ) AS goals_per_match,

    ROUND(
        SUM(goals_against) * 1.0 /
        NULLIF(SUM(matches_played),0),
        2
    ) AS goals_conceded_per_match,

    SUM(shots) AS total_shots,
    SUM(shots_target) AS total_shots_target,

    ROUND(
        SUM(shots_target) * 100.0 /
        NULLIF(SUM(shots),0),
        2
    ) AS shot_accuracy_pct,

    ROUND(
        SUM(goals_for) * 100.0 /
        NULLIF(SUM(shots),0),
        2
    ) AS conversion_rate_pct,

    SUM(clean_sheet) AS clean_sheets,

    ROUND(
        SUM(clean_sheet) * 100.0 /
        NULLIF(SUM(matches_played),0),
        2
    ) AS clean_sheet_pct,

    SUM(corners) AS total_corners,

    ROUND(
        SUM(corners) * 1.0 /
        NULLIF(SUM(matches_played),0),
        2
    ) AS avg_corners_per_match,

    SUM(fouls) AS total_fouls,

    ROUND(
        SUM(fouls) * 1.0 /
        NULLIF(SUM(matches_played),0),
        2
    ) AS avg_fouls_per_match,

    SUM(yellow_cards) AS total_yellow_cards,

    ROUND(
        SUM(yellow_cards) * 1.0 /
        NULLIF(SUM(matches_played),0),
        2
    ) AS avg_yellow_cards_per_match,

    SUM(red_cards) AS total_red_cards,

    ROUND(
        SUM(red_cards) * 1.0 /
        NULLIF(SUM(matches_played),0),
        2
    ) AS avg_red_cards_per_match

FROM team_stats

GROUP BY team;


-- ============================================================
-- View: League Performance Summary

---

-- Purpose:
-- Provides league-wide performance metrics for Overall,
-- Home, and Away teams.
------------------------

-- Grain:
-- One row per metric.
----------------------

-- Structure:
-- Metric | Overall | Home | Away
---------------------------------

-- Used In:
-- Dashboard 1 - League Overview
-- Home Advantage Analysis
-- ============================================================

CREATE VIEW league_performance_summary AS

-- Matches
SELECT
'Matches' AS metric,
COUNT(*) AS overall,
COUNT(*) AS home,
COUNT(*) AS away
FROM match_features

UNION ALL

-- Wins
SELECT
'Wins',
SUM(home_points = 3) + SUM(away_points = 3),
SUM(home_points = 3),
SUM(away_points = 3)
FROM match_features

UNION ALL

-- Draws
SELECT
'Draws',
SUM(home_points = 1),
SUM(home_points = 1),
SUM(home_points = 1)
FROM match_features

UNION ALL

-- Losses
SELECT
'Losses',
SUM(home_points = 0) + SUM(away_points = 0),
SUM(home_points = 0),
SUM(away_points = 0)
FROM match_features

UNION ALL

-- Win %
SELECT
'Win %',
ROUND(
(SUM(home_points = 3) + SUM(away_points = 3))
* 100.0 / (COUNT(*) * 2),
2
),
ROUND(
SUM(home_points = 3) * 100.0 / COUNT(*),
2
),
ROUND(
SUM(away_points = 3) * 100.0 / COUNT(*),
2
)
FROM match_features

UNION ALL

-- Draw %
SELECT
'Draw %',
ROUND(
SUM(home_points = 1) * 100.0 / COUNT(*),
2
),
ROUND(
SUM(home_points = 1) * 100.0 / COUNT(*),
2
),
ROUND(
SUM(home_points = 1) * 100.0 / COUNT(*),
2
)
FROM match_features

UNION ALL

-- Loss %
SELECT
'Loss %',
ROUND(
(SUM(home_points = 0) + SUM(away_points = 0))
* 100.0 / (COUNT(*) * 2),
2
),
ROUND(
SUM(home_points = 0) * 100.0 / COUNT(*),
2
),
ROUND(
SUM(away_points = 0) * 100.0 / COUNT(*),
2
)
FROM match_features

UNION ALL

-- Goals
SELECT
'Goals',
SUM(home_goals + away_goals),
SUM(home_goals),
SUM(away_goals)
FROM match_features

UNION ALL

-- Avg Goals per Match
SELECT
'Avg Goals per Match',
ROUND(AVG(home_goals + away_goals), 2),
ROUND(AVG(home_goals), 2),
ROUND(AVG(away_goals), 2)
FROM match_features

UNION ALL

-- Shots
SELECT
'Shots',
SUM(home_shots + away_shots),
SUM(home_shots),
SUM(away_shots)
FROM match_features

UNION ALL

-- Avg Shots per Match
SELECT
'Avg Shots per Match',
ROUND(AVG(home_shots + away_shots), 2),
ROUND(AVG(home_shots), 2),
ROUND(AVG(away_shots), 2)
FROM match_features

UNION ALL

-- Shots on Target
SELECT
'Shots on Target',
SUM(home_shots_target + away_shots_target),
SUM(home_shots_target),
SUM(away_shots_target)
FROM match_features

UNION ALL

-- Avg Shots on Target per Match
SELECT
'Avg Shots on Target per Match',
ROUND(AVG(home_shots_target + away_shots_target), 2),
ROUND(AVG(home_shots_target), 2),
ROUND(AVG(away_shots_target), 2)
FROM match_features

UNION ALL

-- Shot Accuracy %
SELECT
'Shot Accuracy %',
ROUND(
SUM(home_shots_target + away_shots_target) * 100.0 /
NULLIF(SUM(home_shots + away_shots),0),
2
),
ROUND(
SUM(home_shots_target) * 100.0 /
NULLIF(SUM(home_shots),0),
2
),
ROUND(
SUM(away_shots_target) * 100.0 /
NULLIF(SUM(away_shots),0),
2
)
FROM match_features

UNION ALL

-- Conversion Rate %
SELECT
'Conversion Rate %',
ROUND(
SUM(home_goals + away_goals) * 100.0 /
NULLIF(SUM(home_shots + away_shots),0),
2
),
ROUND(
SUM(home_goals) * 100.0 /
NULLIF(SUM(home_shots),0),
2
),
ROUND(
SUM(away_goals) * 100.0 /
NULLIF(SUM(away_shots),0),
2
)
FROM match_features

UNION ALL

-- Corners
SELECT
'Corners',
SUM(home_corners + away_corners),
SUM(home_corners),
SUM(away_corners)
FROM match_features

UNION ALL

-- Avg Corners per Match
SELECT
'Avg Corners per Match',
ROUND(AVG(home_corners + away_corners), 2),
ROUND(AVG(home_corners), 2),
ROUND(AVG(away_corners), 2)
FROM match_features

UNION ALL

-- Fouls
SELECT
'Fouls',
SUM(home_fouls + away_fouls),
SUM(home_fouls),
SUM(away_fouls)
FROM match_features

UNION ALL

-- Avg Fouls per Match
SELECT
'Avg Fouls per Match',
ROUND(AVG(home_fouls + away_fouls), 2),
ROUND(AVG(home_fouls), 2),
ROUND(AVG(away_fouls), 2)
FROM match_features

UNION ALL

-- Yellow Cards
SELECT
'Yellow Cards',
SUM(home_yellow + away_yellow),
SUM(home_yellow),
SUM(away_yellow)
FROM match_features

UNION ALL

-- Avg Yellow Cards per Match
SELECT
'Avg Yellow Cards per Match',
ROUND(AVG(home_yellow + away_yellow), 2),
ROUND(AVG(home_yellow), 2),
ROUND(AVG(away_yellow), 2)
FROM match_features

UNION ALL

-- Red Cards
SELECT
'Red Cards',
SUM(home_red + away_red),
SUM(home_red),
SUM(away_red)
FROM match_features

UNION ALL

-- Avg Red Cards per Match
SELECT
'Avg Red Cards per Match',
ROUND(AVG(home_red + away_red), 2),
ROUND(AVG(home_red), 2),
ROUND(AVG(away_red), 2)
FROM match_features

UNION ALL

-- Clean Sheets
SELECT
'Clean Sheets',
SUM(home_clean_sheet = 'Yes') + SUM(away_clean_sheet = 'Yes'),
SUM(home_clean_sheet = 'Yes'),
SUM(away_clean_sheet = 'Yes')
FROM match_features

UNION ALL

-- Clean Sheet %
SELECT
'Clean Sheet %',
ROUND(
(SUM(home_clean_sheet = 'Yes') + SUM(away_clean_sheet = 'Yes'))
* 100.0 / (COUNT(*) * 2),
2
),
ROUND(
SUM(home_clean_sheet = 'Yes') * 100.0 / COUNT(*),
2
),
ROUND(
SUM(away_clean_sheet = 'Yes') * 100.0 / COUNT(*),
2
)
FROM match_features;
