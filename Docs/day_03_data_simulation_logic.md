# Day 3: Data Simulation & Chaos Strategy

## 1.0 Simulation Scope (Global Parameters)

We are generating a controlled dataset that is small enough to validate manually but complex enough to require SQL for analysis.

* **Time Horizon:** 12 Months (January 1, 2024 – December 31, 2024).
* **Entity Volume:** 1,000 Unique Customers.
* **Billing Cadence:** Monthly (Invoices generated on the 1st or anniversary date).
* **Product Catalog:**
    * **Basic:** $10.00 / month
    * **Pro:** $50.00 / month
    * **Enterprise:** $200.00 / month

---

## 2.0 The "Chaos Matrix" (Anomaly Injection)

This section defines the precise logic to "break" the data. This simulated leakage is what we will "discover" in our later analysis.

### Scenario A: The "Ghost Subscriber" (Missing Invoices)
* **Business Definition:** Active service, no bill generated.
* **Injection Logic (Python Rule):**
    * Iterate through active subscriptions.
    * **Condition:** Random < 0.015 (1.5% Probability per month).
    * **Action:** **SKIP** generating a row in the invoices table for this month.
* **Data Signature:**
    * `subscriptions.status = 'Active' AND invoices.invoice_id IS NULL` (for current period).

### Scenario B: The "Zombie Account" (Unpaid & Active)
* **Business Definition:** User stopped paying, but system failed to cut access.
* **Injection Logic (Python Rule):**
    * Iterate through generated invoices.
    * **Condition:** Random < 0.02 (2.0% Probability).
    * **Action:**
        * Do **NOT** generate a row in payments.
        * Force `subscriptions.status` to remain 'Active' despite `today > invoice.due_date + 60`.
* **Data Signature:**
    * `invoices.status = 'Unpaid' AND subscriptions.status = 'Active' AND datediff(now, due_date) > 30`.

### Scenario C: The "Leaky Bucket" (Partial Payments)
* **Business Definition:** Payment received is less than invoiced, but system marks it "Settled".
* **Injection Logic (Python Rule):**
    * Iterate through valid payments.
    * **Condition:** Random < 0.03 (3.0% Probability).
    * **Action:**
        * Calculate `payment_amount = invoice.amount * random.uniform(0.90, 0.99)`.
        * Set `invoices.status = 'Settled'`.
* **Data Signature:**
    * `invoices.status = 'Settled' AND payments.amount_paid < invoices.amount`.

---

## 3.0 "Normal Noise" (False Positives)
*(Designing Reality)*

To ensure the analysis is realistic, we must include "messy" data that is valid, ensuring we don't flag correct behavior as errors.

### 3.1 Legitimate Churn
* **Rule:** 8-10% of users will cancel their subscription during the year.
* **Mechanism:** Update `subscriptions.status` to 'Cancelled' and stop generating future invoices.
* **Why:** A user stopping payment **after** cancelling is **not** leakage; it is correct behavior.

### 3.2 Late Payments (Cash Flow Delay)
* **Rule:** 10% of payments occur after the `due_date`.
* **Mechanism:** `payment_date = due_date + random.randint(1, 20)`.
* **Why:** These must be filtered out. They are not "Zombies" because the money eventually arrives.

---

## 4.0 Technical Summary (For Python Scripting)

**Global Settings:**
* **Customers:** 1,000
* **Timeline:** 2024-01-01 to 2024-12-31

**Anomaly Rules (The Leakage):**
* **Missing Invoices (Error Code 101):**
    * Frequency: ~1.5% of Active Subs per month.
    * Mechanism: Skip invoice row creation.
* **Unpaid Accounts (Error Code 102):**
    * Frequency: ~2.0% of total invoices.
    * Mechanism: No payment row + Force Sub Active.
* **Partial Payments (Error Code 103):**
    * Frequency: ~3.0% of total payments.
    * Mechanism: `amount_paid = invoice_amount * (0.90 to 0.99)`.

**Business Logic:**
* **Payment Terms:** Net-14 (Due 14 days after invoice).
* **Churn Rate:** 8% annual churn (Stop invoice generation).