{{ config(materialized='table') }}

-- 1) Monthly portfolio KPIs from the monthly user grain
WITH base AS (
  SELECT
    month,
    COUNT(DISTINCT user_id)                                      AS customers,
    AVG(SAFE_CAST(risk_score AS FLOAT64))                        AS avg_risk_score,
    SUM(SAFE_CAST(exposure   AS FLOAT64))                        AS total_exposure,
    COUNTIF(SAFE_CAST(risk_score AS FLOAT64) >= 7)               AS high_risk_customers
  FROM {{ ref('risk__scores_monthly') }}
  GROUP BY month
),

-- 2) Add an index for moving-average windows
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

-- 3) Final select
SELECT
  month,
  customers,
  avg_risk_score,
  total_exposure,
  high_risk_customers,
  AVG(avg_risk_score) OVER (
    ORDER BY rn ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
  ) AS avg_risk_score_ma3,
  AVG(total_exposure) OVER (
    ORDER BY rn ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
  ) AS total_exposure_ma3
FROM idx
ORDER BY month
