{{ config(materialized='table') }}

WITH data AS (
  SELECT * FROM UNNEST([
    -- ===== DEC 2024 (backfill) =====
    STRUCT(29 AS user_id,  DATE '2024-12-08' AS txn_date, 160.00 AS amount, 'Grocery'      AS merchant_category),
    STRUCT(40 AS user_id,  DATE '2024-12-15' AS txn_date,  60.00 AS amount, 'Restaurant'   AS merchant_category),
    STRUCT(58 AS user_id,  DATE '2024-12-12' AS txn_date,  90.00 AS amount, 'Clothing'     AS merchant_category),
    STRUCT(61 AS user_id,  DATE '2024-12-20' AS txn_date, 120.00 AS amount, 'Travel'       AS merchant_category),
    STRUCT(64 AS user_id,  DATE '2024-12-05' AS txn_date,  15.00 AS amount, 'Coffee'       AS merchant_category),

    -- ===== JAN 2025 =====
    STRUCT(29 AS user_id,  DATE '2025-01-05' AS txn_date, 120.00 AS amount, 'Grocery'      AS merchant_category),
    STRUCT(40 AS user_id,  DATE '2025-01-12' AS txn_date,  45.00 AS amount, 'Restaurant'   AS merchant_category),
    STRUCT(58 AS user_id,  DATE '2025-01-08' AS txn_date,  75.00 AS amount, 'Clothing'     AS merchant_category),
    STRUCT(61 AS user_id,  DATE '2025-01-17' AS txn_date, 150.00 AS amount, 'Travel'       AS merchant_category),
    STRUCT(64 AS user_id,  DATE '2025-01-19' AS txn_date,   9.00 AS amount, 'Coffee'       AS merchant_category),

    -- ===== FEB 2025 =====
    STRUCT(29 AS user_id,  DATE '2025-02-10' AS txn_date, 260.00 AS amount, 'Electronics'  AS merchant_category),
    STRUCT(40 AS user_id,  DATE '2025-02-02' AS txn_date,  90.00 AS amount, 'Gas'          AS merchant_category),
    STRUCT(58 AS user_id,  DATE '2025-02-18' AS txn_date, 110.00 AS amount, 'Grocery'      AS merchant_category),
    STRUCT(61 AS user_id,  DATE '2025-02-25' AS txn_date, 200.00 AS amount, 'Subscription' AS merchant_category),
    STRUCT(64 AS user_id,  DATE '2025-02-05' AS txn_date,  60.00 AS amount, 'Grocery'      AS merchant_category)
  ])
)
SELECT
  CAST(user_id AS INT64)            AS user_id,
  CAST(txn_date AS DATE)            AS txn_date,
  CAST(amount AS FLOAT64)           AS amount,
  CAST(merchant_category AS STRING) AS merchant_category
FROM data
