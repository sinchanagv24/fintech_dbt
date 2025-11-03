{{ config(materialized='table') }}

with src as (
  select user_id, txn_date, amount, merchant_category
  from {{ ref('fct_transactions') }}
)
select
  date_trunc(txn_date, month) as month,
  user_id,
  sum(amount) as monthly_spend,
  count(*)    as txn_count
from src
group by 1, 2
order by 1, 2
