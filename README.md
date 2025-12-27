# Revenue Leakage & Subscription Integrity Analysis (WIP)

**Current Status:** 🚧 Active Development (Currently at Day 9)

This repository documents a project to build, break, and analyze a B2B SaaS billing system. I engineered a "Chaos Matrix" to inject realistic billing failures, then used SQL to track down **$18,000+** in lost revenue.

---

### 🗺️ How to Navigate This Project

This project is structured chronologically. To follow the "story," go through the files in this order:

#### Phase 1: The Plan & Design
1.  **Start with the Business Logic:**
    * 📄 Read `docs/day_01_business_logic.md` to see the leakage scenarios (Ghosts, Zombies, Leaky Buckets).
2.  **See the Blueprint:**
    * 📄 Read `docs/day_02_data_design.md` to see the 5-table schema and ER Diagram.
3.  **Understand the "Chaos":**
    * 📄 Read `docs/day_03_data_simulation_logic.md` to see how I planned to break the data intentionally.

#### Phase 2: The Build (Python & Data)
4.  **The Engine:**
    * 🐍 Check `scripts/data_generator.py`. This is the Python script that generated the 11,000+ records.
5.  **The Evidence:**
    * 💾 Look at the `data/` folder for the raw CSVs.

#### Phase 3: The Detective Work (SQL Analysis)
6.  **Validation:**
    * 🔍 Run `analysis/SQL/02_import_validation.sql` to verify the data load.
7.  **The Investigation:**
    * 🔍 Run `analysis/SQL/05_forensic_analysis.sql`. This is the script that isolates specific "leaking" `invoice_ids`.
    * 📄 Read `docs/day_08_root_cause_analysis.md` for the explanation.

#### Phase 4: The Executive Brief (Business Intelligence)
8.  **The Aggregation:**
    * 🔍 Run `analysis/SQL/06_trends_and_segmentation.sql` to calculate risk by Plan and Month.
9.  **The Final Verdict:**
    * 📄 **Read `docs/day_09_executive_summary.md`.** This is the high-level report summarizing the financial impact.

---

### 📊 Key Business Insights (Day 9 Findings)
After analyzing the synthetic dataset, the SQL analysis revealed:

* **Primary Driver:** **90.31%** of all revenue loss comes from "Zombie Accounts" (invoices generated but strictly unpaid).
* **High-Risk Segment:** The **Enterprise Plan** is the single largest point of failure, accounting for **~$13,000** in lost revenue (vs only ~$800 for Basic plans).
* **Volatility:** Leakage is not linear; it spiked drastically in March 2024 ($2,424 lost), suggesting a specific batch-processing failure event.

---

### 📂 Quick Folder Reference

| Folder | What's Inside? |
| :--- | :--- |
| **`analysis/SQL/`** | Numbered SQL scripts (01-06) to run in MySQL Workbench. |
| **`data/`** | The raw CSV files waiting to be imported into the database. |
| **`docs/`** | The daily logs and explanations. This is the "Journal" of the project. |
| **`scripts/`** | Python tools used to generate the dataset. |

---

### 📝 Current Progress
* **✅ Day 1-5:** Planning, Data Generation, DB Setup.
* **✅ Day 7:** Proved leakage exists ($1,247 lost in Sept).
* **✅ Day 8:** Identified the "Hit List" of specific leaking IDs.
* **✅ Day 9:** Summarized findings by Plan and Root Cause.
* **🔜 Day 10:** Final Dashboard Visualization.