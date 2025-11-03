{{ config(materialized='table') }}

WITH src AS (
  SELECT
    month,
    user_id,
    age,
    limit_balance,
    total_spend,
    txn_count,
    COALESCE(utilization_ratio, 0.0) AS utilization_ratio,
    COALESCE(recent_pay_status, 0.0) AS recent_pay_status
  FROM {{ ref('risk__base_metrics_monthly') }}
)

SELECT
  month,
  user_id,
  age,
  CASE
    WHEN age IS NULL THEN 'Unknown'
    WHEN age < 25   THEN '18–24'
    WHEN age < 35   THEN '25–34'
    WHEN age < 45   THEN '35–44'
    WHEN age < 55   THEN '45–54'
    WHEN age < 65   THEN '55–64'
    ELSE '65+'
  END AS age_group,
  limit_balance,
  total_spend,
  txn_count,
  utilization_ratio,
  recent_pay_status,

  CASE
    WHEN utilization_ratio > 0.8 OR recent_pay_status > 1 THEN 'High Risk'
    WHEN utilization_ratio BETWEEN 0.5 AND 0.8             THEN 'Medium Risk'
    ELSE 'Low Risk'
  END AS risk_category,

  -- 0–100 score: 70% utilization (0–1), 30% pay_status scaled (0–3 -> 0–1)
  (70 * utilization_ratio * 100.0)
    + (30 * LEAST(GREATEST(recent_pay_status, 0), 3) * (100.0 / 3.0)) AS risk_score,

  COALESCE(limit_balance, 0) * COALESCE(utilization_ratio, 0) AS exposure
FROM src
