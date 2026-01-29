with months as (
    {{ dbt_utils.date_spine(
        datepart="month",
        start_date="cast('2020-01-01' as date)",
        end_date="cast('2030-01-01' as date)"
    ) }}
),
accounts as (
    select distinct account_id from {{ ref('stg_subscriptions') }}
),
spine as (
    select
        cast(date_month as date) as month_start,
        {{ dbt.last_day('date_month', 'month') }} as month_end,
        accounts.account_id
    from months
    cross join accounts
),
joined as (
    select
        spine.month_end,
        spine.account_id,
        coalesce(sum(subs.subscription_arr_usd), 0) as total_arr
    from spine
    left join {{ ref('stg_subscriptions') }} subs
        on spine.account_id = subs.account_id
        -- Business Logic: Active in the last day of the month
        and subs.start_date <= spine.month_end
        and subs.end_date >= spine.month_end
    group by 1, 2
)
select * from joined