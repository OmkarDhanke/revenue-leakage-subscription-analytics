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
    * [cite_start]**Reference:** `customers`, `plans`[cite: 56, 60, 65].
    * [cite_start]**Transactional:** `subscriptions`, `invoices`, `payments`[cite: 57, 71, 76, 81].
* [cite_start]**Validation:** Conducted a "Mental Walkthrough" to ensure the schema supports SQL queries for Ghost, Zombie, and Leaky Bucket scenarios[cite: 91, 94, 98, 102].
* [cite_start]**Design Choice:** Utilized `DECIMAL` data types for financial accuracy[cite: 69].

👉 **[Read the Detailed Data Design Doc](Docs/day_02_data_design.md)**