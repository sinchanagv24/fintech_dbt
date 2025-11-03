{{
  config(
    materialized='table',
    tags=['ml_forecast'],
    pre_hook=[
      "
      CREATE OR REPLACE MODEL `{{ target.project }}.{{ target.schema }}.risk_avg_risk_arima_model`
      OPTIONS(
        MODEL_TYPE = 'ARIMA_PLUS',
        time_series_timestamp_col = 'month',
        time_series_data_col      = 'avg_risk_score',
        auto_arima                = TRUE,
        holiday_region            = 'US'
      ) AS
      SELECT month, avg_risk_score
      FROM `{{ target.project }}.{{ target.schema }}.risk__portfolio_trends`
      ORDER BY month
      "
    ]
  )
}}

WITH actuals AS (
  SELECT
    month,
    avg_risk_score                                AS value,
    CAST(NULL AS FLOAT64)                         AS lower,
    CAST(NULL AS FLOAT64)                         AS upper,
    'actual'                                      AS kind
  FROM `{{ target.project }}.{{ target.schema }}.risk__portfolio_trends`
),
forecast AS (
  SELECT
    DATE_TRUNC(CAST(forecast_timestamp AS DATE), MONTH) AS month,
    forecast_value                                      AS value,
    prediction_interval_lower_bound                     AS lower,
    prediction_interval_upper_bound                     AS upper,
    'forecast'                                          AS kind
  FROM ML.FORECAST(
    MODEL `{{ target.project }}.{{ target.schema }}.risk_avg_risk_arima_model`,
    STRUCT(6 AS horizon, 0.9 AS confidence_level)
  )
)

SELECT * FROM actuals
UNION ALL
SELECT * FROM forecast
ORDER BY month, kind
