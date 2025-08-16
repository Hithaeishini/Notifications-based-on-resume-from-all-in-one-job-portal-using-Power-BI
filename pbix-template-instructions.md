# PBIX Template Instructions

1) **Load Data**
- Get Data → Text/CSV:
  - `data/resume_sample.csv` as `ResumeProfile`
  - `data/skills_dictionary.csv` as `Skills`
  - All CSVs in `data/job_feeds/` as a single table `Jobs` (or use `JobsCombine.pq`).

2) **Power Query**
- Create Blank Query `ResumeSkills` and paste `ResumeParser.pq`.
- Create Blank Query `Jobs` and paste `JobsCombine.pq` (or keep your combined CSV load).

3) **Model**
- Ensure relationships: `Jobs` ↔ `JobSkills` ↔ `Skills` and `ResumeSkills` ↔ `Skills`. Connect `ResumeProfile` to slicers.

4) **Report Pages**
- **Home**: Slicers for Location, Experience, Source; KPI cards for Total Jobs, Matches.
- **Matches**: Table with Title, Company, Source, Score; bar chart of Score by Source.
- **Notifications**: Filter `Top Match = 1` and recent `posted_date` (e.g., last 7 days). Card: `New Today`. Table with `job_url` links.

5) **Formatting**
- Conditional formatting on Score column (icons or data bars).
- Bookmark a “No Matches” state vs “Top Matches” and add toggle button.

6) **Parameters**
- Create a table `Parameters` with column `TopMatchThreshold` (single value 0.6). Bind measure to it or use What-if parameter.

7) **Publish (Optional)**
- Publish to Power BI Service to pin KPI cards and configure data-driven alerts (optional, no extra libraries).
