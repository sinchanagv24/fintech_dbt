{{ config(materialized='table') }}

SELECT
  non_seasonal_p,
  non_seasonal_d,
  non_seasonal_q,
  AIC,
  variance
FROM `{{ target.project }}.{{ target.schema }}.risk__avg_risk_arima_evaluate`
ORDER BY AIC
LIMIT 1;
