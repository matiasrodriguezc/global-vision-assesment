import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

# Data results from dbt model (fct_mrr_movements)
data = {
    'month': [
        '2021-09-30', '2021-10-31', '2022-08-31', # Period 1 (Inicio)
        '2022-09-30', '2023-08-31',               # Period 2 (Upgrade)
        '2023-09-30', '2024-11-30',               # Period 3 (Downgrade)
        '2024-12-31', '2025-10-31',               # Period 4 (Reactivation/New logic)
        '2025-11-30',                             # Period 5 (Churn Gap)
        '2025-12-31', '2026-12-31'                # Period 6 (Reactivation Final)
    ],
    'total_arr': [
        2440.2, 2440.2, 2440.2,    # 2021-2022
        34362.4, 34362.4,          # 2022-2023 (High Value)
        18900.0, 18900.0,          # 2023-2024 (Stabilized)
        18900.0, 18900.0,          # 2024-2025
        0.0,                       # Nov 2025 (Churn)
        18900.0, 18900.0           # Dec 2025 (Reactivation)
    ]
}

df = pd.DataFrame(data)
df['month'] = pd.to_datetime(df['month'])

fig, ax = plt.subplots(figsize=(12, 6))

ax.step(df['month'], df['total_arr'], where='post', color='#004c6d', linewidth=2, label='ARR Total')
ax.plot(df['month'], df['total_arr'], 'o', color='#004c6d', markersize=4)

ax.xaxis.set_major_locator(mdates.MonthLocator(interval=6))
ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m'))
plt.xticks(rotation=45)

plt.title('ARR Monthly Evolution (Client 12345)', fontsize=14, pad=20)
plt.ylabel('ARR (USD)', fontsize=12)
plt.xlabel('Date', fontsize=12)
plt.grid(True, linestyle='--', alpha=0.6)
plt.tight_layout()

plt.savefig('arr_chart.png')
print("Gráfico guardado como arr_chart.png")
plt.show()