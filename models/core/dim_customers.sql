{{ config(materialized='table') }}

select
  cast(user_id as string) as user_id,
  age,
  sex,
  education_level,
  marital_status,
  limit_balance,
  recent_pay_status,
  default_next_month,
  predicted_default_next_month
from {{ ref('stg_credit_card_default') }}
