with raw as (
  select * from {{ source('ml_datasets','credit_card_default') }}
)
select
  cast(id as string) as user_id,
  limit_balance as limit_balance,
  sex,
  education_level,
  marital_status,
  age,
  pay_0 as recent_pay_status,
  bill_amt_1, bill_amt_2, bill_amt_3, bill_amt_4, bill_amt_5, bill_amt_6,
  pay_amt_1,  pay_amt_2,  pay_amt_3,  pay_amt_4,  pay_amt_5,  pay_amt_6,
  default_payment_next_month as default_next_month,
  predicted_default_payment_next_month as predicted_default_next_month
from raw
