# Data Dictionary

**Dataset:** Premier League 2025/26 Match Data  
**Source:** Football-data.co.uk  

---

## Match Information

| Column | Data Type | Meaning |
|---|---|---|
| Div | VARCHAR | League division identifier |
| Date | VARCHAR | Match date in raw format (DD/MM/YYYY) |
| HomeTeam | VARCHAR | Team playing at home |
| AwayTeam | VARCHAR | Team playing away |
| FTHG | INT | Full-time home goals |
| FTAG | INT | Full-time away goals |
| FTR | CHAR | Full-time result |
| HTHG | INT | Half-time home goals |
| HTAG | INT | Half-time away goals |
| HTR | CHAR | Half-time result |
| Referee | VARCHAR | Match referee |

---

## Match Statistics

| Column | Data Type | Meaning |
|---|---|---|
| HS | INT | Total shots by home team |
| AS | INT | Total shots by away team |
| HST | INT | Home team shots on target |
| AST | INT | Away team shots on target |
| HF | INT | Home team fouls |
| AF | INT | Away team fouls |
| HC | INT | Home team corners |
| AC | INT | Away team corners |
| HY | INT | Home team yellow cards |
| AY | INT | Away team yellow cards |
| HR | INT | Home team red cards |
| AR | INT | Away team red cards |

---

## Betting Odds

| Column | Data Type | Meaning |
|---|---|---|
| AvgH | DECIMAL | Average bookmaker odds for home team win |
| AvgD | DECIMAL | Average bookmaker odds for draw |
| AvgA | DECIMAL | Average bookmaker odds for away team win |
| Avg>2.5 | DECIMAL | Average odds for over 2.5 total goals |
| Avg<2.5 | DECIMAL | Average odds for under 2.5 total goals |
| AH | DECIMAL | Asian handicap market value |

---

## Result Values

| Value | Meaning |
|---|---|
| H | Home Win |
| D | Draw |
| A | Away Win |

---

## Data Transformation Notes

| Raw Column | SQL Column | Transformation |
|---|---|---|
| Date | match_date | Converted from VARCHAR (DD/MM/YYYY) into SQL DATE format |
| HomeTeam | home_team | Renamed for consistency |
| AwayTeam | away_team | Renamed for consistency |
| FTHG | home_goals | Renamed for analysis |
| FTAG | away_goals | Renamed for analysis |
| FTR | full_time_result | Renamed for readability |
| HS, AS, HST, AST, etc. | match_statistics table | Separated into statistics table |
| AvgH, AvgD, AvgA, etc. | odds table | Separated into betting odds table |

---

## Database Structure

| Table | Purpose |
|---|---|
| matches | Stores match details and results |
| match_statistics | Stores team performance statistics |
| odds | Stores betting market information |
| premier_league_analysis | View combining all match data for analysis |
