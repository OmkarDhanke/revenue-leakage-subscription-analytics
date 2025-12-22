import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

# ==========================================
# 1. SETUP & CONFIGURATION
# ==========================================
np.random.seed(42)
NUM_CUSTOMERS = 1000
START_DATE = datetime(2024, 1, 1)
END_DATE = datetime(2024, 12, 31)

# Anomaly Rates
MISSING_INVOICE_RATE = 0.015
UNPAID_INVOICE_RATE = 0.02
PARTIAL_PAYMENT_RATE = 0.03

print("🚀 Starting Data Generation")

# ==========================================
# 2. GENERATE REFERENCE TABLES
# ==========================================
# --- Plans ---
plans_data = {
    'plan_id': [1, 2, 3],
    'plan_name': ['Basic', 'Pro', 'Enterprise'],
    'monthly_price': [10.00, 50.00, 200.00]
}
df_plans = pd.DataFrame(plans_data)

# --- Customers ---
customer_ids = range(1001, 1001 + NUM_CUSTOMERS)
regions = ['North', 'South', 'East', 'West']
df_customers = pd.DataFrame({
    'customer_id': customer_ids,
    'customer_name': [f'Customer_{i}' for i in customer_ids],
    'email': [f'contact_{i}@example.com' for i in customer_ids],
    'region': np.random.choice(regions, NUM_CUSTOMERS)
})

# ==========================================
# 3. GENERATE SUBSCRIPTIONS
# ==========================================
subscriptions = []
for cust_id in df_customers['customer_id']:
    # Start dates mostly before 2024 to ensure full year of data
    days_offset = np.random.randint(-700, 0) 
    sub_start = START_DATE + timedelta(days=days_offset)
    
    # 10% Churn Rate
    if np.random.rand() < 0.10:
        sub_end = START_DATE + timedelta(days=np.random.randint(30, 360))
        status = 'Cancelled'
    else:
        sub_end = END_DATE
        status = 'Active'

    plan_id = np.random.choice(df_plans['plan_id'])
    
    subscriptions.append([
        len(subscriptions) + 5001,
        cust_id,
        plan_id,
        sub_start.date(),
        sub_end.date(),
        status
    ])

df_subscriptions = pd.DataFrame(subscriptions, columns=['sub_id', 'customer_id', 'plan_id', 'start_date', 'end_date', 'status'])

# ==========================================
# 4. GENERATE INVOICES
# ==========================================
invoices = []
current_date = START_DATE

# Loop through every month of 2024
while current_date <= END_DATE:
    # Find active subs for this month
    active_subs = df_subscriptions[
        (pd.to_datetime(df_subscriptions['start_date']) <= current_date) & 
        (pd.to_datetime(df_subscriptions['end_date']) >= current_date)
    ]
    
    for _, sub in active_subs.iterrows():
        # --- ANOMALY 1: GHOST SUBSCRIBER ---
        # Randomly skip generating an invoice
        if np.random.rand() < MISSING_INVOICE_RATE:
            continue

        plan_price = df_plans.loc[df_plans['plan_id'] == sub['plan_id'], 'monthly_price'].values[0]
        
        invoices.append([
            len(invoices) + 10001,
            sub['sub_id'],
            current_date.date(),
            (current_date + timedelta(days=14)).date(), # Net 14
            plan_price # amount
        ])
    
    # ✅ BUG FIX: Robust Month Increment logic
    # Using DateOffset correctly handles the Year Rollover (Dec -> Jan)
    current_date = current_date + pd.DateOffset(months=1)

df_invoices = pd.DataFrame(invoices, columns=['invoice_id', 'sub_id', 'invoice_date', 'due_date', 'amount'])

# ==========================================
# 5. GENERATE PAYMENTS
# ==========================================
payments = []
for _, inv in df_invoices.iterrows():
    # --- ANOMALY 2: ZOMBIE ACCOUNT ---
    if np.random.rand() < UNPAID_INVOICE_RATE:
        # NOTE: Subscriptions linked to unpaid invoices are intentionally left as 'Active'
        # to simulate access-control failure (Zombie Accounts).
        # We skip the payment row, but we do NOT update the subscription status.
        continue

    pay_date = pd.to_datetime(inv['invoice_date']) + timedelta(days=np.random.randint(0, 20))
    pay_amount = inv['amount']

    # --- ANOMALY 3: LEAKY BUCKET ---
    if np.random.rand() < PARTIAL_PAYMENT_RATE:
        pay_amount = round(pay_amount * np.random.uniform(0.90, 0.99), 2)

    payments.append([
        len(payments) + 20001,
        inv['invoice_id'],
        pay_date.date(),
        pay_amount
    ])

df_payments = pd.DataFrame(payments, columns=['payment_id', 'invoice_id', 'payment_date', 'amount_paid'])

# ==========================================
# 6. EXPORT
# ==========================================
df_customers.to_csv('customers.csv', index=False)
df_plans.to_csv('plans.csv', index=False)
df_subscriptions.to_csv('subscriptions.csv', index=False)
df_invoices.to_csv('invoices.csv', index=False)
df_payments.to_csv('payments.csv', index=False)

print("✅ Data Generation Complete (Final Fixed Version v1.2)")
print(f"Total Invoices: {len(df_invoices)}")
print(f"Total Payments: {len(df_payments)}")
print(f"Difference (Leakage): {len(df_invoices) - len(df_payments)} unpaid invoices")