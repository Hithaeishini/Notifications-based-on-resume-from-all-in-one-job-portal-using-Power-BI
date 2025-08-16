# DAX Measures & Calculated Columns

## Bridge Table
Create a bridge table `JobSkills` by using Power Query step `SplitSkills` (already done). It will have one row per job-skill.

Create dimension `Skills` from `skills_dictionary.csv` (distinct `skill`).

## Relationships
- `JobSkills[required_skills]` → `Skills[skill]` (many-to-one)
- `ResumeSkills[skill]` → `Skills[skill]` (many-to-one)
- `JobSkills[job_id]` → `Jobs[job_id]` (many-to-one)

## Measures
```
Skill Matches = 
COUNTROWS(
    INTERSECT(
        VALUES(ResumeSkills[skill]),
        VALUES(JobSkills[required_skills])
    )
)

Resume Skill Weight = 
VAR MatchTable =
    NATURALINNERJOIN(
        VALUES(ResumeSkills[skill]),
        VALUES(JobSkills[required_skills])
    )
RETURN
SUMX(
    MatchTable,
    COALESCE(RELATED(Skills[priority]), 1)
)

Skill Match % = 
VAR AllReq = CALCULATE(DISTINCTCOUNT(JobSkills[required_skills]), ALLEXCEPT(Jobs, Jobs[job_id]))
RETURN DIVIDE([Skill Matches], AllReq, 0)
```

Assuming `Jobs` has `experience_min` and `experience_max`, and a disconnected table `ResumeProfile` with `ExperienceYears` (from `resume_sample.csv`):

```
Experience Fit =
VAR yrs = SELECTEDVALUE(ResumeProfile[ExperienceYears], 0)
VAR lo  = MIN(Jobs[experience_min])
VAR hi  = MAX(Jobs[experience_max])
RETURN
IF(yrs < lo, 0, IF(yrs > hi, 0.8, 1))
```

Overall score:
```
Overall Fit Score =
0.6 * [Skill Match %] +
0.3 * [Experience Fit] +
0.1 * [Location/Type Fit]
```

Location fit (simple text contains):
```
Location/Type Fit =
VAR prefLoc = SELECTEDVALUE(ResumeProfile[PreferredLocation], "any")
VAR prefType = SELECTEDVALUE(ResumeProfile[PreferredType], "any")
VAR locFit = IF(SEARCH(LOWER(prefLoc), LOWER(CONCATENATEX(VALUES(Jobs[location]), Jobs[location], ", ")),,0) > 0, 1, 0.5)
VAR typeFit = IF(SEARCH(LOWER(prefType), LOWER(CONCATENATEX(VALUES(Jobs[job_type]), Jobs[job_type], ", ")),,0) > 0, 1, 0.5)
RETURN (locFit + typeFit) / 2
```

Flag for Notifications (adjust threshold as needed):
```
Top Match = IF([Overall Fit Score] >= SELECTEDVALUE(Parameters[TopMatchThreshold], 0.6), 1, 0)
New Today = IF(Jobs[posted_date] = TODAY(), 1, 0)
```

Use these fields in filters on the **Notifications** page.
