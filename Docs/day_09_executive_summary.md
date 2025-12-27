# 9.0 Executive Insights Report


## 1. Trend Analysis (Is it getting worse?)
* **Trend:** Leakage is volatile. It does not follow a clean linear pattern, but rather spikes unpredictably.
* **Key Observation:** The highest loss occurred in **March 2024**, where **$2,424.20** was lost in a single month. This is significantly higher than months like April ($756.47), suggesting specific batch processing failures or seasonal anomalies.

## 2. Root Cause Breakdown (Where is the money going?)
We analyzed the breakdown of lost revenue by category:

| Leakage Category | Count | Total Lost ($) | % of Total |
| :--- | :--- | :--- | :--- |
| **Unpaid Invoices (Zombies)** | 209 | $16,570.00 | 90.31% |
| **Partial Payments** | 327 | $1,368.15 | 7.46% |
| **Missing Invoices (Ghosts)** | 13 | $410.00 | 2.23% |

* **Insight:** The overwhelming majority of revenue loss (**90.31%**) comes from **Unpaid Invoices (Zombie Accounts)**. While Partial Payments are the most frequent error (327 counts), their financial impact is minor compared to the total loss from unpaid bills. Our primary focus must be on **Collections Recovery**.

## 3. Product Risk (Which plan is affected?)
* **Highest Risk Plan:** **Enterprise**
* **Total Loss:** **$12,994.56**
* **Analysis:** The Enterprise tier accounts for the lion's share of the leakage. Even though there may be fewer Enterprise customers than Basic ones, a single "Zombie" Enterprise account (200/mo) Causes 20x the damage of a Basic Account ($10/mo). 

## 4. Conclusion
The data confirms that revenue leakage is a systemic issue driven primarily by **high-value "Zombie" accounts** in the Enterprise tier.

**Strategic Recommendation:**
1.  **Immediate Action:** The Collections Team must prioritize the **209 Unpaid Invoices** identified in the `leakage_report`.
2.  **Process Change:** Implement a hard "Service Cutoff" for Enterprise accounts that remain unpaid after 45 days (Net-14 + 30 Day Grace).
3.  **Automation:** The "Ghost Subscriber" issue (Missing Invoices), while financially smaller ($410), represents a dangerous technical failure that must be patched by Engineering.