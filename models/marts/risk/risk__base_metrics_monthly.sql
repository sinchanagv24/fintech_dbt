{{ config(materialized='table') }}

WITH customers AS (
  SELECT
    CAST(user_id AS INT64)                                  AS user_id,
    CAST(age AS FLOAT64)                                    AS age,
    CAST(limit_balance AS FLOAT64)                          AS limit_balance,
    GREATEST(CAST(recent_pay_status AS FLOAT64), 0.0)       AS recent_pay_status
  FROM {{ ref('stg_credit_card_default') }}
),

tx_monthly AS (
  SELECT
    CAST(user_id AS INT64)           AS user_id,
    DATE_TRUNC(txn_date, MONTH)      AS month,
    SUM(amount)                      AS total_spend,
    COUNT(*)                         AS txn_count
  FROM {{ ref('fct_transactions') }}
  GROUP BY 1,2
)

SELECT
  t.month,
  t.user_id,
  -- bring customer attrs if present
  c.age,
  c.limit_balance,
  COALESCE(t.total_spend, 0.0)       AS total_spend,
  COALESCE(t.txn_count, 0)           AS txn_count,
  -- utilization: spend / limit, safe and clipped
  LEAST(
    COALESCE(SAFE_DIVIDE(COALESCE(t.total_spend, 0.0), NULLIF(c.limit_balance, 0.0)), 0.0),
    1.0
  )                                  AS utilization_ratio,
  COALESCE(c.recent_pay_status, 0.0) AS recent_pay_status
FROM tx_monthly t
LEFT JOIN customers c
  ON c.user_id = t.user_id
