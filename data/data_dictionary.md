# Data Dictionary

This document describes the datasets used in the Premier League Analytics project.

The original match dataset was cleaned, transformed, and separated into relational tables before analysis.

---

# Table: matches

Contains match-level information including teams, results, and match context.

| Column | Data Type | Description |
|---|---|---|
| match_id | Integer | Unique identifier for each match |
| division | String | League division/competition identifier |
| match_date | Date | Date when the match was played |
| home_team | String | Team playing at home |
| away_team | String | Team playing away |
| full_time_result | String | Full-time match result (H = Home win, D = Draw, A = Away win) |
| home_goals | Integer | Goals scored by the home team at full time |
| away_goals | Integer | Goals scored by the away team at full time |
| half_home_goals | Integer | Goals scored by home team at half time |
| half_away_goals | Integer | Goals scored by away team at half time |
| half_time_result | String | Half-time result (H, D, A) |
| referee | String | Match referee |

---

# Table: match_statistics

Contains match performance statistics for both teams.

| Column | Data Type | Description |
|---|---|---|
| stats_id | Integer | Unique identifier for statistics record |
| match_id | Integer | Links statistics to matches table |
| home_shots | Integer | Total shots by home team |
| away_shots | Integer | Total shots by away team |
| home_shots_target | Integer | Home team shots on target |
| away_shots_target | Integer | Away team shots on target |
| home_corners | Integer | Corners taken by home team |
| away_corners | Integer | Corners taken by away team |
| home_fouls | Integer | Fouls committed by home team |
| away_fouls | Integer | Fouls committed by away team |
| home_yellow | Integer | Yellow cards received by home team |
| away_yellow | Integer | Yellow cards received by away team |
| home_red | Integer | Red cards received by home team |
| away_red | Integer | Red cards received by away team |

---

# Table: odds

Contains betting market information associated with each match.

| Column | Data Type | Description |
|---|---|---|
| odds_id | Integer | Unique identifier for odds record |
| match_id | Integer | Links odds to matches table |
| avg_home_odds | Decimal | Average betting odds for home team win |
| avg_draw_odds | Decimal | Average betting odds for draw |
| avg_away_odds | Decimal | Average betting odds for away team win |
| avg_over_25 | Decimal | Average odds for over 2.5 total goals |
| avg_under_25 | Decimal | Average odds for under 2.5 total goals |
| asian_handicap | Decimal | Asian handicap betting line |

---

# Table: match_features

Contains engineered features created from match results, statistics, and odds.

These features were created to support trend analysis and identify relationships between team performance and match outcomes.

| Column | Data Type | Description |
|---|---|---|
| match_id | Integer | Unique match identifier |
| match_date | Date | Date of match |
| home_team | String | Home team |
| away_team | String | Away team |
| home_goals | Integer | Home team goals |
| away_goals | Integer | Away team goals |
| home_shots | Integer | Home team total shots |
| away_shots | Integer | Away team total shots |
| home_shots_target | Integer | Home team shots on target |
| away_shots_target | Integer | Away team shots on target |
| home_corners | Integer | Home team corners |
| away_corners | Integer | Away team corners |
| home_fouls | Integer | Home team fouls |
| away_fouls | Integer | Home team fouls |
| home_yellow | Integer | Home team yellow cards |
| away_yellow | Integer | Away team yellow cards |
| home_red | Integer | Home team red cards |
| away_red | Integer | Away team red cards |
| avg_home_odds | Decimal | Average home win odds |
| avg_draw_odds | Decimal | Average draw odds |
| avg_away_odds | Decimal | Average away win odds |
| goal_difference | Integer | Difference between home and away goals |
| total_goals | Integer | Combined goals scored in match |
| home_shot_accuracy | Decimal | Home shots on target divided by total shots |
| away_shot_accuracy | Decimal | Away shots on target divided by total shots |
| home_conversion_rate | Decimal | Home goals divided by shots on target |
| away_conversion_rate | Decimal | Away goals divided by shots on target |
| total_corners | Integer | Combined corners from both teams |
| corner_difference | Integer | Difference between home and away corners |
| total_fouls | Integer | Combined fouls committed |
| total_yellow_cards | Integer | Combined yellow cards |
| total_red_cards | Integer | Combined red cards |
| red_card_match | String | Indicates whether match contained a red card |
| over_2_5_goals | String | Indicates whether match had over 2.5 goals |
| home_clean_sheet | String | Indicates whether home team conceded no goals |
| away_clean_sheet | String | Indicates whether away team conceded no goals |
| home_points | Integer | Points earned by home team (3 win, 1 draw, 0 loss) |
| away_points | Integer | Points earned by away team (3 win, 1 draw, 0 loss) |

---

# Notes

## Result Codes

| Code | Meaning |
|---|---|
| H | Home team win |
| D | Draw |
| A | Away team win |

## Feature Engineering

The `match_features` table contains derived metrics created from the original match data.

Examples:

- Goal difference
- Total goals
- Shot accuracy
- Conversion rate
- Total corners
- Clean sheet indicators
- Points earned

These features are used for SQL analysis and identifying patterns such as home advantage, team performance, and match outcome trends.

## Missing Values

Missing values are stored as NULL where information is unavailable.

Values were not replaced with estimated values to avoid introducing assumptions into the analysis.
