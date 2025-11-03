{{ config(materialized='table') }}

with src as (
  select
    cast(user_id as int64)             as user_id,
    cast(age as float64)               as age,
    cast(limit_balance as float64)     as limit_balance,
    cast(total_spend as float64)       as total_spend,
    cast(txn_count as int64)           as txn_count,
    cast(utilization_ratio as float64) as utilization_ratio,
    cast(recent_pay_status as float64) as recent_pay_status,
    case
      when coalesce(cast(recent_pay_status as float64), 0.0) < 0 then 0.0
      when coalesce(cast(recent_pay_status as float64), 0.0) > 2 then 2.0
      else coalesce(cast(recent_pay_status as float64), 0.0)
    end as clipped_pay_status
  from {{ ref('risk__base_metrics') }}
),

util_stats as (
  select
    coalesce(APPROX_QUANTILES(utilization_ratio, 100)[OFFSET(95)], 0.30) as util_p95
  from src
),

scaled as (
  select
    s.*,
    least(
      coalesce(safe_divide(coalesce(s.utilization_ratio, 0.0), nullif(u.util_p95, 0.0)), 0.0),
      1.0
    ) as util_scaled,
    coalesce(safe_divide(s.clipped_pay_status, 2.0), 0.0) as pay_scaled
  from src s
  cross join util_stats u
)

select
  user_id,
  age,
  limit_balance,
  total_spend,
  txn_count,
  utilization_ratio,
  recent_pay_status,

  case
    when utilization_ratio > 0.8 or recent_pay_status > 1 then 'High Risk'
    when utilization_ratio between 0.5 and 0.8             then 'Medium Risk'
    else 'Low Risk'
  end as risk_category,

  round( (0.70 * util_scaled + 0.30 * pay_scaled) * 100, 2) as risk_score,
  (limit_balance * utilization_ratio) as exposure
from scaled
