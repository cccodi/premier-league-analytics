-- ============================================================
-- Premier League Analytics Project
-- File: 01_database_setup.sql
--
-- Purpose:
-- Create database tables for storing Premier League match data,
-- match statistics, and betting odds for analysis.
-- ============================================================

USE premier_league_analytics;


-- ============================================================
-- Table: matches
--
-- Stores match-level information including:
-- teams, scores, results, and referee details.
--
-- match_date is stored as VARCHAR initially because the raw
-- dataset uses DD/MM/YYYY format. It will be converted during
-- the data cleaning step.
-- ============================================================

CREATE TABLE matches (

    match_id INT AUTO_INCREMENT PRIMARY KEY,

    division VARCHAR(10),

    match_date VARCHAR(10),

    home_team VARCHAR(50),
    away_team VARCHAR(50),


    -- Match result:
    -- H = Home Win
    -- D = Draw
    -- A = Away Win

    full_time_result CHAR(1),


    home_goals INT,
    away_goals INT,


    -- Half-time score

    half_home_goals INT,
    half_away_goals INT,


    -- Half-time result:
    -- H = Home Win
    -- D = Draw
    -- A = Away Win

    half_time_result CHAR(1),


    referee VARCHAR(50)

);



-- ============================================================
-- Table: match_statistics
--
-- Stores match performance metrics:
-- shots, corners, fouls, and discipline statistics.
--
-- These columns will be used for analysis and feature
-- engineering later in the project.
-- ============================================================

CREATE TABLE match_statistics (

    stats_id INT AUTO_INCREMENT PRIMARY KEY,
    
    match_id INT,

    home_shots INT,
    away_shots INT,

    home_shots_target INT,
    away_shots_target INT,

    home_corners INT,
    away_corners INT,

    home_fouls INT,
    away_fouls INT,

    home_yellow INT,
    away_yellow INT,

    home_red INT,
    away_red INT,


    CONSTRAINT fk_match_statistics
    FOREIGN KEY (match_id)
    REFERENCES matches(match_id)

);



-- ============================================================
-- Table: odds
--
-- Stores betting market information.
-- Used as additional features to compare expected outcomes
-- with actual match results.
-- ============================================================

CREATE TABLE odds (

    odds_id INT AUTO_INCREMENT PRIMARY KEY,

    match_id INT,

    avg_home_odds DECIMAL(5,2),
    avg_draw_odds DECIMAL(5,2),
    avg_away_odds DECIMAL(5,2),

    avg_over_25 DECIMAL(5,2),
    avg_under_25 DECIMAL(5,2),

    asian_handicap DECIMAL(4,2),


    CONSTRAINT fk_match_odds
    FOREIGN KEY (match_id)
    REFERENCES matches(match_id)

);



-- ============================================================
-- Verify table creation
-- ============================================================

SHOW TABLES;