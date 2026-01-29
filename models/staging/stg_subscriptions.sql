with source as (
    select * from {{ ref('subscription_data') }}
),
cleaned as (
    select
        account_id,
        subscription_id,
        subscription_product_line,
        subscription_status,  
        subscription_arr_usd,
        --(Swap)
        case 
            when subscription_start_date > subscription_end_date then subscription_end_date 
            else subscription_start_date 
        end as start_date,
        case 
            when subscription_start_date > subscription_end_date then subscription_start_date 
            else subscription_end_date 
        end as end_date
    from source
)
select * from cleaned