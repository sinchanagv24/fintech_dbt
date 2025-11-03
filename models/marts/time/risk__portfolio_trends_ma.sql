{{ config(materialized='table') }}

WITH base AS (
  SELECT
    month,
    customers,
    avg_risk_score,
    total_exposure,
    high_risk_customers
  FROM {{ ref('risk__portfolio_trends') }}
),
-- build a month index so we can do window frames in BigQuery
idx AS (
  SELECT
    month,
    customers,
    avg_risk_score,
    total_exposure,
    high_risk_customers,
    ROW_NUMBER() OVER (ORDER BY month) AS rn
  FROM base
)
SELECT
  month,
  customers,
  avg_risk_score,
  total_exposure,
  high_risk_customers,
  -- 3-point moving average
  AVG(avg_risk_score) OVER (ORDER BY rn ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS avg_risk_score_ma3,
  AVG(total_exposure) OVER (ORDER BY rn ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS total_exposure_ma3
FROM idx
ORDER BY month
