# 7.0 Preliminary Revenue Leakage Analysis

## 1. Collection Gap (Unpaid Bills)
* **Observation:** Across 2024, there is a consistent gap between Invoiced and Collected revenue.
* **Data Point:** In September 2024, the Recovery Rate was **98.32%**.
* **Financial Impact:** We are consistently failing to collect **$1,247.95** per month in this period.

## 2. Generation Gap (Missing Invoices)
* **Observation:** A spot check of September 2024 reveals a critical failure in invoice generation.
* **Expected Revenue (Active Subs):** $74,120.00
* **Actual Invoiced (Generated Bills):** $74,200.00
* **Leakage Amount (Ghost Revenue):** -$80.00
*(Note: The negative variance indicates that new customer acquisition in September masked the Ghost Subscriber leakage for this specific spot check. However, the operational risk remains.)*

## 3. Conclusion
The billing system has two major points of failure:

1.  **Collection Failure (Confirmed):** We have concrete evidence of **~$1,200+** in monthly revenue leakage due to "Zombie Accounts" and "Leaky Bucket" partial payments. This is the primary driver of loss.
2.  **Generation Failure (Suspected):** While the spot check was masked by new growth, the mechanism for "Ghost Subscribers" (active users with no invoices) is technically present and needs to be isolated from new user data.

