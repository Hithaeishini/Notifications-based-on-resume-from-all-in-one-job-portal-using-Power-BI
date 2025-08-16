# 🔔 Job Portals in One (Power BI) — Resume‑Based Match & Alerts

A **Power BI** project that unifies jobs from multiple portals (Naukri, LinkedIn, Indeed, Shine, Foundit, Cutshort) and matches them to a user's **resume**. The report highlights the **best matches** and a **Notifications** page surfaces roles to apply for.

> No external libraries or custom visuals. Built with **Power BI Desktop** only (Power Query + DAX + native visuals).

---

## ✨ What this does
- **Upload your resume** (paste text or import a simple CSV).
- **Ingest job feeds** from multiple portals (provided as CSV samples).
- **Parse skills** from resume text using Power Query (keyword dictionary).
- **Score matches** with DAX (skills, experience, location) to compute an **Overall Fit Score**.
- **Notifications page** shows *Top Matches* (configurable threshold).

> ⚠️ Note: Real APIs from job portals are not used. Replace the sample CSVs with your own exports/scrapes (CSV only) to stay within “no external libraries/installations.”

---

## 🗂 Project structure
```
job-portals-powerbi/
├─ data/
│  ├─ resume_sample.csv
│  ├─ skills_dictionary.csv
│  └─ job_feeds/
│     ├─ naukri.csv
│     ├─ linkedin.csv
│     ├─ indeed.csv
│     ├─ shine.csv
│     ├─ foundit.csv
│     └─ cutshort.csv
├─ scripts/
│  └─ powerquery/
│     ├─ ResumeParser.pq
│     └─ JobsCombine.pq
├─ DAX.md
├─ pbix-template-instructions.md
├─ report-wireframe.png
├─ LICENSE
└─ README.md
```

---

## 🚀 How to use (Desktop)
1. Open **Power BI Desktop**.
2. **Get Data → Text/CSV** and load every CSV from `data/` and `data/job_feeds/`.
3. Open **Power Query** → *New Source → Blank Query* → paste M from `scripts/powerquery/*.pq` where indicated.
4. Ensure relationships are created (see wireframe). At minimum:
   - `Jobs[required_skills]` (text) maps via split to `Skills[skill]` (many-to-many using bridge `JobSkills`).
   - `ResumeSkills[skill]` connects to `Skills[skill]`.
5. Back in the report canvas, add visuals per **pbix-template-instructions.md** or replicate the attached wireframe.
6. Adjust the **threshold** (`Parameters[TopMatchThreshold]`, default 0.6) to control what appears as **Notifications**.

---

## 🔔 “Notifications” without external services
- The **Notifications page** filters to `OverallFitScore >= TopMatchThreshold` and `PostedDate` within the last *N* days.
- A **card** shows the count of *New Matches Today*.
- A **table** lists job title, company, score, and an actionable `job_url` link column.
- Use **conditional formatting** (Data bars / Icons) to highlight top matches.

> Tip: If you publish to the Power BI Service, you can pin a score **card** to a dashboard and enable **Data-driven alerts** (optional).

---

## 🧠 Matching logic (simplified)
- **Skills match (60%)**: overlap between resume skills and job required skills (weighted by priority).
- **Experience fit (30%)**: resume years vs. job min/max.
- **Location/Type match (10%)**: preferred location/remote vs. job location/type.

Editable in `DAX.md` and Power Query scripts.

---

## 📥 Replace sample data
- Update `resume_sample.csv` with your info or paste your text into **Power Query** UI (per `ResumeParser.pq` comments).
- Replace CSVs in `data/job_feeds/` with your own exported job lists (same columns).

---

## 🧱 Limitations
- Power BI cannot trigger native “popup” dialogs. This project simulates notifications via **report pages**, filters, and conditional formats.
- Real-time scraping/APIs are **not** included to keep things self-contained and dependency-free.

---

## 📄 License
MIT — see `LICENSE`.
