{{
  config(materialized='table')
}}

SELECT
  *
FROM ML.EVALUATE(
  MODEL `{{ target.project }}.{{ target.schema }}.risk_avg_risk_arima_model`
)
