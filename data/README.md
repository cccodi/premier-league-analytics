# Data

This folder contains the datasets used for the Premier League Analytics project.

## Data Source

The original dataset was collected from Premier League match records for the 2025/26 season.

The dataset contains match-level information including:

- Match date
- Home and away teams
- Match results
- Goals scored
- Match statistics
- Betting odds

## Raw Data

`raw/premier_league_2025_26.csv`

This is the original extracted dataset before cleaning and transformation.

## Processed Data

The raw dataset was cleaned, transformed, and separated into relational tables.

### matches.csv

Contains match-level information.

Example fields:
- match_id
- date
- home_team
- away_team
- home_goals
- away_goals
- result

### match_statistics.csv

Contains team performance statistics.

Example fields:
- match_id
- home_shots
- away_shots
- home_shots_on_target
- away_shots_on_target
- corners
- fouls
- yellow_cards
- red_cards

### odds.csv

Contains betting odds data.

Example fields:
- match_id
- home_odds
- draw_odds
- away_odds

### match_features.csv

Contains engineered features created for analysis.

These features combine match results and statistics to support trend analysis and insights.

Example fields:
- match_id
- goal_difference
- total_goals
- shot_difference
- shots_on_target_difference
- home_advantage indicators
- performance metrics

## Usage

These datasets are used for SQL analysis to explore:

- Home advantage
- Team performance trends
- Attacking and defensive efficiency
- Relationship between statistics and match outcomes
- Betting odds patterns
