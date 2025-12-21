# Project Journal

## Day 1: Business Thinking & Data Design
**Focus:** Defined the business context for "CloudFlow" (B2B SaaS) and mapped the revenue leakage scenarios.

* **Status:** ✅ Complete
* **Key Achievements:**
    * Mapped the "Order-to-Cash" operational workflow to identify failure points.
    * Defined 3 critical leakage scenarios:
        1.  **The Ghost Subscriber:** Active users with missing invoices.
        2.  **The Zombie Account:** Non-paying users who were not suspended.
        3.  **The Leaky Bucket:** Partial payments incorrectly marked as settled.
* **Scope Decision:** Confirmed focus is strictly on operational billing failures, not marketing churn.

👉 **[Read the Detailed Day 1 Report](Docs/day_01_business_logic.md)**

## Day 2: Data Architecture & Schema Design
**Focus:** Designed the Relational Database schema to support the leakage analysis.

* **Status:** ✅ Complete
* **Key Output:** Defined the 5-table schema:
    * **Reference:** `customers`, `plans`.
    * **Transactional:** `subscriptions`, `invoices`, `payments`.
* **Validation:** Conducted a "Mental Walkthrough" to ensure the schema supports SQL queries for Ghost, Zombie, and Leaky Bucket scenarios.
* **Design Choice:** Utilized `DECIMAL` data types for financial accuracy.

👉 **[Read the Detailed Data Design Doc](Docs/day_02_data_design.md)**

## Day 3: Simulation Strategy & Chaos Matrix
**Focus:** Designed the Python logic to generate synthetic data with "Intentional Flaws."

* **Status:** ✅ Complete
* **The "Chaos Matrix" (Defined Error Rates):**
    1.  **Ghost Subscribers:** 1.5% probability (Missing Invoices).
    2.  **Zombie Accounts:** 2.0% probability (Unpaid + Active). Added **Grace Period Logic** (Net-14 + 30 days) to distinguish zombies from late payers.
    3.  **Leaky Bucket:** 3.0% probability. Defined that settlement status will be **derived** via SQL, not hardcoded.
* **Realism Factor:** Included "Normal Noise" (8-10% churn, 10% late payments) to prevent false positives.
* **Constraint:** Set dataset scope to 1,000 customers over a 12-month period (2024).

👉 **[Read the Detailed Simulation Logic](Docs/day_03_data_simulation_logic.md)**