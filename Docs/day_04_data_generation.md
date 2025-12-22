# Day 4: Creation of Synthetic Data

## 1.0 Executive Summary
To validate the revenue leakage hypotheses I defined in Phase 1, I needed data. Since real-world financial data is sensitive and hard to get, I wrote a Python script to generate a **Synthetic Dataset** that mimics a real-world SaaS billing engine.

This wasn't just random noise; I "rigged" the data with specific **Chaos Parameters** to ensure my SQL queries would have something to find.

* **Total Volume:** 1,000 Customers / ~11,800 Invoices.
* **Timeframe:** Jan 1, 2024 – Dec 31, 2024.
* **Reproducibility:** I enforced `np.random.seed(42)` so the output is identical every time I run it.

---

## 2.0 Configuration Parameters
I hardcoded the following logic gates into the script to simulate the specific business anomalies we discussed yesterday:

| Parameter | Value | Simulation Effect |
| :--- | :--- | :--- |
| **MISSING_INVOICE_RATE** | **1.5%** | **"Ghost Subscribers":** Active users who miss a monthly bill generation due to system error. |
| **UNPAID_INVOICE_RATE** | **2.0%** | **"Zombie Accounts":** Invoices generated but unpaid, where the user *incorrectly* remains Active. |
| **PARTIAL_PAYMENT_RATE** | **3.0%** | **"Leaky Bucket":** Payments received that are mathematically lower than the Invoice Amount. |

---

## 3.0 Source Code Logic (ETL)
**Status:** Validated (v1.2)

**Key Logic Fixes:**
* ✅ **Month Roll-Over:** I used `pd.DateOffset` to prevent crashes when the date rolls over from December to January.
* ✅ **Zombie Logic:** The script explicitly leaves the subscription status as 'Active' even when it skips the payment row.
* ✅ **High-Volume Mode:** I backdated user acquisition to ensure we had a full year of invoice density (~11k rows) rather than starting from zero in January.

---

## 4.0 Output Verification Checklist
Before moving to the SQL analysis, I ran a quick sanity check on the CSV files:

1.  **File Inventory:** Confirmed all 5 files exist (`customers.csv`, `plans.csv`, `subscriptions.csv`, `invoices.csv`, `payments.csv`).
2.  **Volume Check:**
    * `invoices.csv` row count is > 11,000.
    * `payments.csv` row count is lower than invoices (proving Leakage exists).
3.  **Schema Check:** Confirmed the columns match my SQL schema design from Day 2.

### Python Script
**[Read the Detailed Python Script](Scripts/data_generator.py)**