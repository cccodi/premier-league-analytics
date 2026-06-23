# Premier League Analytics Project ⚽

## Overview

This project demonstrates an end-to-end data analytics workflow, from raw data
preparation and SQL-based analysis to dashboard development and future
predictive modeling.

---

## Project Status

Current progress:

✅ Data cleaning and validation  
✅ SQL analysis and feature engineering  
✅ Home vs away performance analysis  
🚧 Dashboard development  
🔜 Machine learning extension

---

## Objectives

- Analyze overall league performance
- Generate league standings from match results
- Evaluate home vs away performance
- Identify attacking and defensive trends
- Compare betting odds with actual results
- Prepare dashboard-ready metrics

---

## Dataset

The dataset contains Premier League match information including:

- Match results
- Goals scored
- Shots and shots on target
- Corners
- Fouls
- Cards
- Betting odds

Dataset files:

```text
data/
├── matches.csv
├── match_statistics.csv
└── odds.csv
```

More details:

- [Data Dictionary](docs/data_dictionary.md)

---

## SQL Workflow

The project follows a structured analytics workflow:

```text
01_database_setup.sql
        ↓
02_data_cleaning_validation.sql
        ↓
03_exploratory_analysis.sql
        ↓
04_feature_engineering.sql
        ↓
05_views.sql
        ↓
06_dashboard_queries.sql
```

### SQL Files

| File | Purpose |
|---|---|
| 01_database_setup.sql | Creates database and table structure |
| 02_data_cleaning_validation.sql | Cleans and validates imported data |
| 03_exploratory_analysis.sql | Performs exploratory analysis |
| 04_feature_engineering.sql | Creates reusable performance metrics |
| 05_views.sql | Creates reusable SQL views |
| 06_dashboard_queries.sql | Generates dashboard-ready queries |

---

## Analysis Covered

### League Performance

- Total matches
- Total goals
- Average goals per match
- League standings

### Team Performance

- Wins, draws, and losses
- Goals scored and conceded
- Goal difference
- Points comparison

### Home Advantage Analysis

- Home vs away points
- Home vs away goals
- Team-level home advantage

### Match Analysis

- Result distribution
- Shooting efficiency
- Odds vs actual results
- Match intensity

---

## Key Findings

- Home teams achieved higher average points compared with away teams,
  demonstrating measurable home advantage.
- Goal-scoring patterns varied significantly across teams.
- Attacking efficiency differed between high-performing and mid-table teams.
- Match statistics provided additional context beyond final results.

---

## Tools & Technologies

Database:
- MySQL

Analysis:
- SQL
- Excel
- Python

Visualization:
- Power BI
- Tableau

Version Control:
- GitHub

---

## Project Structure

```text
Premier-League-Analytics/

├── README.md
│
├── data/
│   ├── matches.csv
│   ├── match_statistics.csv
│   └── odds.csv
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_data_cleaning_validation.sql
│   ├── 03_exploratory_analysis.sql
│   ├── 04_feature_engineering.sql
│   ├── 05_views.sql
│   └── 06_dashboard_queries.sql
│
├── docs/
│   ├── findings.md
│   └── data_dictionary.md
│
└── dashboard/
```

---

## Author

Clarisse
