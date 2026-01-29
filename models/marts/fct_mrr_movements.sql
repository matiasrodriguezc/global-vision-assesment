with monthly_revenue as (
    select * from {{ ref('int_revenue_by_month') }}
),
lagged as (
    select
        *,
        lag(total_arr) over (partition by account_id order by month_end) as prev_arr,
        -- Detect if there was a revenue before (to distinguish New from Reactivation)
        max(total_arr) over (partition by account_id order by month_end rows between unbounded preceding and 1 preceding) as historical_max_arr
    from monthly_revenue
),
categorized as (
    select
        *,
        total_arr - coalesce(prev_arr, 0) as arr_change,
        case
            when coalesce(prev_arr, 0) = 0 and total_arr > 0 and coalesce(historical_max_arr, 0) > 0 then 'Reactivation'
            when coalesce(prev_arr, 0) = 0 and total_arr > 0 then 'New'
            when coalesce(prev_arr, 0) > 0 and total_arr = 0 then 'Churn'
            when total_arr > prev_arr then 'Upgrade'
            when total_arr < prev_arr then 'Downgrade'
            else 'No-change'
        end as change_category
    from lagged
)
select * from categorized
where month_end <= '2026-12-31';