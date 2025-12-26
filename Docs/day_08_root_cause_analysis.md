# Phase 8: Root Cause Classification


## 1.0 Forensic Strategy
To enable the Operations team to fix these issues, we cannot just say "we lost $1,200." We must provide a list of specific IDs. We classified leakage into three types:

1.  **Zombie Accounts:** Invoices generated but strictly unpaid (`payment_id IS NULL`).
2.  **Leaky Buckets:** Invoices partially paid (`amount_paid < invoice_amount`).
3.  **Ghost Subscribers:** Active subscriptions with ZERO invoices generated for the billing period.

## 2.0 The "Hit List" (leakage_report Table)
We utilized a `UNION ALL` query to combine these disparate error types into a single, standardized table: `leakage_report`.

### Table Schema (Generated)
| Column Name | Description |
| :--- | :--- |
| **leakage_date** | The date the error occurred (Invoice Date or Month End). |
| **source_type** | Origin of the error ('Invoice' or 'Subscription'). |
| **source_id** | The specific ID to investigate (`invoice_id` or `sub_id`). |
| **leakage_category** | The classification (Unpaid, Partial, Missing Invoice). |
| **leakage_amount** | The exact dollar value lost. |

## 3.0 SQL Logic Applied
* **Collection Gap:** Used `LEFT JOIN payments` to find NULLs or underpayments.
* **Generation Gap:** Used `NOT EXISTS` logic (via `LEFT JOIN invoices ... WHERE id IS NULL`) to find active users missing bills in September.
