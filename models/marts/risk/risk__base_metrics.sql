{{ config(materialized='table') }}

with customers as (
  select
    cast(user_id as int64)        as user_id,
    cast(age as float64)          as age,
    cast(limit_balance as float64) as limit_balance,
    greatest(cast(recent_pay_status as float64), 0.0) as recent_pay_status,
    -- use bill_amt_1 as a proxy for utilized balance
    greatest(cast(bill_amt_1 as float64), 0.0)        as bill_amt_1
  from {{ ref('stg_credit_card_default') }}
)

select
  user_id,
  age,
  limit_balance,
  /* set spend to bill for the detail table */
  bill_amt_1                           as total_spend,
  cast(0 as int64)                     as txn_count,
  recent_pay_status,
  -- utilization = bill / limit, safe + clipped
  least(
    coalesce(safe_divide(bill_amt_1, nullif(limit_balance, 0.0)), 0.0),
    1.0
  ) as utilization_ratio
from customers
