# Subscription Revenue Modeling (dbt)

This project models Monthly Recurring Revenue (ARR) based on subscription data, handling upgrades, downgrades, churn, and reactivations.

## Overview
- **Stack:** dbt Core, PostgreSQL, Python.
- **Key Features:**
    - Date Spining to generate monthly grain.
    - Automatic handling of inverted start/end dates.
    - MRR Change categorization (New, Churn, Reactivation, etc.).

## How to Run
1. Install dependencies: `pip install -r requirements.txt` (optional)
2. Run dbt:
    ```bash
    dbt deps
    dbt seed
    dbt run
    dbt test
    ```
3. Generate Chart: `python generate_chart.py`

## Assumptions
- Subscriptions with `start_date > end_date` were treated as data entry errors and swapped.
- Revenue is calculated based on active status on the **last day of the month**.