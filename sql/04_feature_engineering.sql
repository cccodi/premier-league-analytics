-- ============================================================
-- Premier League Analytics Project
-- File: 04_feature_engineering.sql
-----------------------------------

-- Purpose:
-- Create derived performance metrics that can be
-- reused for analysis, reporting, and dashboards.
-- ============================================================

USE premier_league_analytics;

-- ============================================================
-- Create feature table
-- ============================================================

CREATE TABLE match_features AS

SELECT

-- Match information

m.match_id,
m.match_date,

m.home_team,
m.away_team,

m.home_goals,
m.away_goals,

-- Shooting statistics

s.home_shots,
s.away_shots,

s.home_shots_target,
s.away_shots_target,

-- Corner statistics

s.home_corners,
s.away_corners,

-- Foul statistics

s.home_fouls,
s.away_fouls,

-- Discipline statistics

s.home_yellow,
s.away_yellow,

s.home_red,
s.away_red,

-- Betting odds

o.avg_home_odds,
o.avg_draw_odds,
o.avg_away_odds,

-- ========================================================
-- Engineered Features
-- ========================================================

-- Goal difference

(m.home_goals - m.away_goals) AS goal_difference,

-- Total goals scored

(m.home_goals + m.away_goals) AS total_goals,

-- Shot accuracy (% of shots that were on target)

ROUND(
    s.home_shots_target * 100.0 /
    NULLIF(s.home_shots, 0),
    2
) AS home_shot_accuracy,

ROUND(
    s.away_shots_target * 100.0 /
    NULLIF(s.away_shots, 0),
    2
) AS away_shot_accuracy,

-- Conversion rate (% of shots on target converted into goals)

ROUND(
    m.home_goals * 100.0 /
    NULLIF(s.home_shots_target, 0),
    2
) AS home_conversion_rate,

ROUND(
    m.away_goals * 100.0 /
    NULLIF(s.away_shots_target, 0),
    2
) AS away_conversion_rate,

-- Corner metrics

(s.home_corners + s.away_corners) AS total_corners,

(s.home_corners - s.away_corners) AS corner_difference,

-- Foul metrics

(s.home_fouls + s.away_fouls) AS total_fouls,

-- Discipline metrics

(s.home_yellow + s.away_yellow) AS total_yellow_cards,

(s.home_red + s.away_red) AS total_red_cards,

CASE
    WHEN (s.home_red + s.away_red) > 0
    THEN 'Yes'
    ELSE 'No'
END AS red_card_match,

-- Over 2.5 goals indicator

CASE
    WHEN (m.home_goals + m.away_goals) >= 3
    THEN 'Yes'
    ELSE 'No'
END AS over_2_5_goals,

-- Clean sheet indicators

CASE
    WHEN m.away_goals = 0
    THEN 'Yes'
    ELSE 'No'
END AS home_clean_sheet,

CASE
    WHEN m.home_goals = 0
    THEN 'Yes'
    ELSE 'No'
END AS away_clean_sheet,

-- Points earned

CASE
    WHEN m.full_time_result = 'H' THEN 3
    WHEN m.full_time_result = 'D' THEN 1
    ELSE 0
END AS home_points,

CASE
    WHEN m.full_time_result = 'A' THEN 3
    WHEN m.full_time_result = 'D' THEN 1
    ELSE 0
END AS away_points

FROM matches m

JOIN match_statistics s
ON m.match_id = s.match_id

JOIN odds o
ON m.match_id = o.match_id;

-- ============================================================
-- Verify feature table creation
-- ============================================================

SELECT COUNT(*) AS total_records
FROM match_features;

SELECT *
FROM match_features
LIMIT 5;
