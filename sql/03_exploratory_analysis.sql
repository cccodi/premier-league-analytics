-- ============================================================
-- Premier League Analytics Project
-- File: 03_exploratory_analysis.sql
--
-- Purpose:
-- Perform exploratory analysis to identify league trends,
-- team performance patterns, match outcomes, and betting insights.
-- ============================================================

USE premier_league_analytics;

-- ============================================================
-- League Overview
-- ============================================================

-- Total matches played

SELECT COUNT(*) AS total_matches
FROM matches;

-- Total goals scored across all matches

SELECT
    SUM(home_goals + away_goals) AS total_goals
FROM matches;

-- Average goals scored per match

SELECT
    ROUND(AVG(home_goals + away_goals), 2) AS avg_goals_per_match
FROM matches;

-- ============================================================
-- Match Results Distribution
-- ============================================================

-- Distribution of home wins, draws, and away wins

SELECT
    full_time_result,
    COUNT(*) AS matches
FROM matches
GROUP BY full_time_result;

-- ============================================================
-- Home Advantage Analysis
-- ============================================================

-- Compare average goals scored by home and away teams

SELECT
    ROUND(AVG(home_goals), 2) AS avg_home_goals,
    ROUND(AVG(away_goals), 2) AS avg_away_goals
FROM matches;

-- Calculate home win percentage

SELECT
    ROUND(
        COUNT(CASE WHEN full_time_result = 'H' THEN 1 END)
        * 100.0 / COUNT(*),
        2
    ) AS home_win_pct
FROM matches;

-- ============================================================
-- Team Performance
-- ============================================================

-- Teams with the highest number of home goals scored

SELECT
    home_team AS team,
    SUM(home_goals) AS goals_scored
FROM matches
GROUP BY home_team
ORDER BY goals_scored DESC;

-- ============================================================
-- High-Scoring Matches
-- ============================================================

-- Top 10 matches with the most goals

SELECT
    match_date,
    home_team,
    away_team,
    home_goals,
    away_goals,
    (home_goals + away_goals) AS total_goals
FROM matches
ORDER BY total_goals DESC
LIMIT 10;

-- ============================================================
-- Shots Analysis
-- ============================================================

-- Average shots attempted by home and away teams

SELECT
    ROUND(AVG(home_shots), 2) AS avg_home_shots,
    ROUND(AVG(away_shots), 2) AS avg_away_shots
FROM match_statistics;

-- Average shots on target by home and away teams

SELECT
    ROUND(AVG(home_shots_target), 2) AS avg_home_sot,
    ROUND(AVG(away_shots_target), 2) AS avg_away_sot
FROM match_statistics;

-- ============================================================
-- Discipline Analysis
-- ============================================================

-- Average yellow cards received

SELECT
    ROUND(AVG(home_yellow), 2) AS avg_home_yellow,
    ROUND(AVG(away_yellow), 2) AS avg_away_yellow
FROM match_statistics;

-- Total red cards recorded during the season

SELECT
    SUM(home_red + away_red) AS total_red_cards
FROM match_statistics;

-- ============================================================
-- Betting Odds Analysis
-- ============================================================

-- Average bookmaker odds by match outcome

SELECT
    ROUND(AVG(avg_home_odds), 2) AS avg_home_odds,
    ROUND(AVG(avg_draw_odds), 2) AS avg_draw_odds,
    ROUND(AVG(avg_away_odds), 2) AS avg_away_odds
FROM odds;

-- Matches with the lowest home odds (strongest home favorites)

SELECT
    m.home_team,
    m.away_team,
    o.avg_home_odds
FROM matches m
JOIN odds o
    ON m.match_id = o.match_id
ORDER BY o.avg_home_odds
LIMIT 10;

-- ============================================================
-- League Statistics Summary
-- ============================================================

-- Average goals scored by match result

SELECT
    full_time_result,
    ROUND(AVG(home_goals + away_goals), 2) AS avg_goals
FROM matches
GROUP BY full_time_result;

-- Average corners earned by home and away teams

SELECT
    ROUND(AVG(home_corners), 2) AS avg_home_corners,
    ROUND(AVG(away_corners), 2) AS avg_away_corners
FROM match_statistics;