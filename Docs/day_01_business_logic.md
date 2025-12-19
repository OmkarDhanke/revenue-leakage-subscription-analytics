# Day 1: Business Thinking & Data Design

## 1. Business Context
To accurately analyze revenue, we must first map the operational flow of the business.

* **Entity Name:** CloudFlow
* **Industry Vertical:** B2B SaaS (Software as a Service) Project Management Solutions.
* **Target Market:** SMBs (small-to-medium businesses) to enterprise-level organizations.
* **Revenue Model:**
    * **Recurring Revenue:** Subscription-based model with monthly and annual auto-renewals.
    * **Pricing Structure:** Tiered access (e.g., Basic at $10/mo, Pro at $50/mo, Enterprise at Custom).
* **Strategic Goal:** To maximize Annual Recurring Revenue (ARR) by identifying and closing billing process gaps.

---

## 2. Operational Workflow
Before identifying errors, we must define the standard "Order-to-Cash" cycle. Any deviation from this logic is considered an anomaly.

1.  **Subscription Activation:** Customer selects a plan; `Subscription_Status` becomes "Active."
2.  **Invoice Generation:** At the billing cycle anchor date (month-end), the ERP system triggers an invoice based on the active plan price.
3.  **Revenue Realization:** The customer processes payment against the specific `Invoice_ID`.
4.  **Reconciliation:** The system matches `Payment_Amount` to `Invoice_Amount` and updates the status to "Settled."

---

## 3. Leakage Hypotheses (Risk Assessment)
*(Where is the money being lost?)*

We are focusing on "revenue leakage"—money CloudFlow **should** have earned but lost due to process inefficiencies. We have identified three specific scenarios that will form the basis of our data analysis.

### Scenario A: The "Ghost" Subscriber (Missing Invoices)
* **Definition:** A customer holds an **active** subscription status and consumes server resources, but the billing engine **fails to generate an invoice record** for the current billing period.
* **Business Impact:** 100% revenue loss on that account. The service is effectively being provided for free due to a system error.
* **Logic for Analysis:**
    * `Subscription_Status = 'Active'` AND `Invoice_Count (Current Month) = 0`

### Scenario B: The "Zombie" Account (Unpaid Invoices)
* **Definition:** An invoice was successfully generated and delivered, but payment was never received. Crucially, the system **failed to suspend the user's access** after the grace period.
* **Business Impact:** **Bad debt** accumulation. CloudFlow is incurring infrastructure costs to support a non-paying customer.
* **Logic for Analysis:**
    * `Invoice_Status = 'Unpaid'` AND `Days_Since_Due > 30` AND `Account_Status = 'Active'`

### Scenario C: The "Leaky Bucket" (Partial Payment Errors)
* **Definition:** A discrepancy where `Amount_Paid` is less than `Invoice_Amount` (e.g., paying $90 on a $100 bill), yet the system incorrectly flags the invoice as "Settled" or "Paid in Full."
* **Business Impact:** Silent margin erosion. Over thousands of transactions, small discrepancies compound into significant losses.
* **Logic for Analysis:**
    * `Status = 'Settled'` BUT `Amount_Paid < Invoice_Amount`

---

## 4. Problem Statement

### Current State:
CloudFlow operates on a high-volume subscription model but is currently experiencing unquantified discrepancies between "Booked Revenue" (expected based on user count) and "Cash Collected" (actual bank deposits).

### The Gap:
* The organization currently lacks granular visibility into the specific points of failure within the billing lifecycle.
* There is no automated mechanism to detect when active users are not billed (Ghosts) or when non-paying users are not suspended (Zombies).

### Project Objective:
This project will conduct a forensic data analysis of CloudFlow’s billing records to:
1.  **Identify** revenue leakage stemming from missing invoices, unpaid accounts, and partial payment logic errors.
2.  **Quantify** the total financial loss (annualized).
3.  **Provide** data-driven recommendations to patch these billing gaps and recover lost revenue.

---

## 5. Day 1 Outcome Summary
* **Business Model Mapped:** Confirmed as Subscription SaaS with auto-renewal.
* **Scope Defined:** Focus strictly on revenue leakage (ghost, zombie, and leaky bucket scenarios). We are **not** analyzing marketing churn or sales performance.
* **Technical Readiness:** Logic checks defined. We know exactly what data anomalies we need to look for in SQL/Python.