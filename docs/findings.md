# Premier League Analytics Project - Findings

---

# League Overview

## Total Matches

**SQL Analysis:**

Calculated the total number of matches in the dataset.

Result:

- Total Matches: **380**

---

## Total Goals Scored

**SQL Analysis:**

Calculated the total goals scored across all matches.

Result:

- Total Goals: **1,045**

---

## Average Goals Per Match

**SQL Analysis:**

Calculated average goals scored per match.

Result:

- Average Goals Per Match: **2.75**

---

# League Standings Analysis

## Overview

Generated a league standings table by aggregating match results into:

- Matches played
- Wins, draws, and losses
- Goals scored (GF)
- Goals conceded (GA)
- Goal difference (GD)
- Total points

## Key Findings

- Arsenal finished top of the table with **85 points**, supported by the highest number of wins (**26**) and the strongest defensive record (**27 goals conceded**).

- Manchester City had the highest attacking output, scoring **77 goals**, the most in the league, but finished second with **78 points**.

- Manchester United achieved third place with **71 points**, showing strong consistency with **20 wins and only 7 losses**.

- The strongest teams combined attacking performance with defensive stability:

| Team | Goals For | Goals Against | Goal Difference |
|---|---:|---:|---:|
| Arsenal | 71 | 27 | +44 |
| Manchester City | 77 | 35 | +42 |
| Manchester United | 69 | 50 | +19 |

- Bournemouth recorded the highest number of draws (**18**), suggesting a balanced but less decisive season.

- Teams with defensive struggles included:

| Team | Goals Against |
|---|---:|
| Burnley | 75 |
| Wolverhampton Wanderers | 68 |
| West Ham | 65 |

- Goal difference separated teams with similar points:
  - Chelsea and Fulham both finished with **52 points**
  - Chelsea ranked higher due to a better goal difference (**+6 vs -4**)

## Interpretation

League success is influenced by multiple factors, not only attacking ability. Teams require a balance between scoring goals, preventing goals, and consistently earning points.

---

# Match Result Distribution

## Key Findings

- Home teams recorded more wins than away teams, indicating the presence of home advantage.

- Draw results accounted for a portion of matches, showing that not every game was determined by home or away strength.

---

# Home Advantage Analysis

## Overview

Compared home and away performance using:

- Goals scored
- Shots
- Corners

## Key Findings

- Home teams generally performed better in attacking metrics.

- Average home goals were higher than average away goals, supporting the influence of:
  - Familiar stadium conditions
  - Crowd support
  - Reduced travel impact

---

# Team-Level Home vs Away Points Analysis

## Overview

Compared each team's total points earned at home versus away.

## Key Findings

- Most teams earned more points at home, supporting the existence of team-level home advantage.

- Strong home advantage examples:

| Team | Home Points | Away Points | Difference |
|---|---:|---:|---:|
| Fulham | 35 | 17 | +18 |
| Leeds | 32 | 15 | +17 |
| Newcastle | 32 | 17 | +15 |
| Manchester United | 42 | 29 | +13 |

- Some teams performed equally or better away:

| Team | Home Points | Away Points |
|---|---:|---:|
| Chelsea | 26 | 26 |
| Everton | 23 | 26 |
| Crystal Palace | 21 | 24 |
| Tottenham | 15 | 26 |

## Interpretation

Home advantage varies between teams. While most clubs benefit from playing at home, some teams maintain stronger away performances.

---

# Team-Level Home vs Away Goals Analysis

## Overview

Compared goals scored at home and away to evaluate attacking performance by venue.

## Key Findings

- Manchester City recorded the highest home goals:

  - Home Goals: **45**
  - Away Goals: **32**

- Arsenal and Manchester United also showed strong home attacking performance.

- Newcastle had the largest home attacking difference:

  - Home Goals: **36**
  - Away Goals: **17**
  - Difference: **+19**

- Some teams scored more away goals:

| Team | Home Goals | Away Goals |
|---|---:|---:|
| Chelsea | 26 | 32 |
| Tottenham | 22 | 26 |
| Nottingham Forest | 20 | 28 |

## Interpretation

Home advantage is reflected in attacking output, although some teams perform effectively away from home.

---

# Team Goal Performance

## Key Findings

Top attacking teams based on total goals scored:

- Manchester City
- Arsenal
- Manchester United
- Liverpool

## Interpretation

Higher-scoring teams generally appeared near the top of the standings, but defensive performance also influenced final rankings.

---

# Shooting Efficiency Analysis

## Overview

Compared shot conversion rates to evaluate attacking efficiency.

## Key Findings

- Teams with stronger conversion rates were able to create more value from their chances.

- Conversion rate provides additional context beyond total goals scored.

---

# Odds vs Results Analysis

## Overview

Compared bookmaker odds with match outcomes.

## Key Findings

- Odds can indicate expected match strength but do not always predict actual results.

- Unexpected results highlight matches where teams exceeded expectations.

---

# Match Intensity Analysis

## Overview

Analyzed physical and disciplinary aspects:

- Fouls
- Yellow cards
- Red cards
- Corners

## Key Findings

- High foul counts indicate more physically intense matches.

- Discipline metrics provide additional context when evaluating team performance.

---

# Overall Conclusion

The analysis shows that Premier League performance depends on multiple factors:

- Consistent point accumulation
- Attacking efficiency
- Defensive stability
- Home advantage
- Match intensity

While top teams usually combine strong attack and defence, some teams rely heavily on home performance to achieve competitive results.
