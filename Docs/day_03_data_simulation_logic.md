# Day 3: Data Simulation & Chaos Strategy

## 1.0 Volume Parameters (The Scale)
* **Time Period:** 1 Year (Jan 2024 – Dec 2024).
* **Total Customers:** 1,000.
* **Plans:** 3 Tiers (Basic $10, Pro $50, Enterprise $200).
* **Billing Frequency:** Monthly.

---

## 2.0 The "Chaos Matrix" (Designing the Leakage)
*(How we break the data without an explicit 'Invoice Status' column)*

### Scenario A: The "Ghost Subscriber" (Missing Invoices)
* **The Logic:** The customer has `subscriptions.status = 'Active'`, but for a specific month, **NO row exists** in the invoices table.
* **Injection Rate:** 1.5% of active subscriptions per month.
* **Mechanism:** During the monthly iteration, skip the invoice generation step for these selected users.
* **Data Signature:**
    * `subscriptions.status = 'Active'` AND `invoices.invoice_id IS NULL` (for current period).

### Scenario B: The "Zombie Account" (Unpaid & Active)
* **The Logic:** An invoice exists, but **NO row exists** in the payments table. Crucially, the user's subscription status remains 'Active' long after the grace period.
* **Injection Rate:** 2% of total invoices.
* **Mechanism:**
    1.  Create the Invoice row.
    2.  Skip creating the matching Payment row.
    3.  Force `subscriptions.status` to remain 'Active' regardless of non-payment.
* **Grace Period Logic:**
    * **Payment Terms:** Net-14 (Due 14 days after invoice).
    * **Zombie Classification:** Applies only after a **30-day grace period** beyond the due date.
    * **SQL Check:** `current_date > (due_date + 30 days)`.

### Scenario C: The "Leaky Bucket" (Partial Payments)
* **The Logic:** A row exists in payments, but the `amount_paid` is **less than** the `invoices.amount`.
* **Note:** Invoice settlement state will be **derived during analysis** based on the presence and amount of the payment record.
* **Injection Rate:** 3% of total payments.
* **Mechanism:**
    1.  Create Payment row.
    2.  Set `amount_paid = invoice_amount * random.uniform(0.90, 0.99)`.
* **Data Signature:**
    * `payments.amount_paid < invoices.amount` (Resulting in a derived status of 'Partially Paid').

---

## 3.0 Designing "Normal Noise" (False Positives)
*(Realism Factors)*

### Churn (Cancellations)
* **Rule:** 8-10% of users cancel.
* **Mechanism:** Update `subscriptions.status` to 'Cancelled'. Stop generating new invoices after that date.

### Late Payments (Cash Flow Delay)
* **Rule:** 10% of payments happen after `due_date`.
* **Mechanism:** `payment_date` is > `due_date`, but `amount_paid == invoice_amount`.
* **Result:** This is valid revenue, not a leak.

---

## 4.0 Technical Summary (For Python Scripting)

**Global Settings:**
* **Customers:** 1,000
* **Timeline:** 2024-01-01 to 2024-12-31

**Anomaly Rules:**
* **Missing Invoices:** Skip invoice row creation (1.5% chance).
* **Unpaid Accounts:** Create invoice but skip payment row creation (2.0% chance).
* **Partial Payments:** Create payment where `amount_paid < invoice_amount` (3.0% chance).

**Business Logic:**
* **Payment Terms:** Net-14.
* **Grace Period:** 30 days (Total 44 days from Invoice Date before "Zombie" status).
* **Churn Rate:** 8% annual churn.