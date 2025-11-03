# 🏦 FinTech Risk & Portfolio Forecast Dashboard  
**Built with dbt + BigQuery + Looker Studio**

---

## 📘 Overview  
This dashboard provides an **end-to-end financial risk analysis and forecasting pipeline**, combining data modeling with predictive analytics.  
It helps executives monitor **portfolio exposure**, **customer risk segmentation**, and **future credit risk trends** using **ARIMA time-series forecasting**.

---

## ⚙️ Tech Stack  
- **Data Modeling:** dbt (modular SQL transformations)  
- **Data Warehouse:** Google BigQuery  
- **Forecasting:** BigQuery ML (ARIMA+)  
- **Visualization:** Looker Studio (interactive dashboard)  

---

## 🧩 Data Architecture  
| Layer | Description | Example Models |
|-------|--------------|----------------|
| **Staging** | Clean and standardize raw data | `stg_credit_card_default` |
| **Core** | Transaction and risk features | `fct_transactions`, `risk__scores` |
| **Marts** | Aggregated metrics and forecasts | `risk__portfolio_trends`, `risk__avg_risk_arima_forecast` |

---

## 📊 Dashboard Sections  

### **1️⃣ Executive Summary**
- **Total Customers:** 2,965  
- **High-Risk %:** 32%  
- **Average Risk Score:** 34.24  
- **Total Exposure:** $152M  

Highlights overall portfolio exposure and risk concentration by segment.  

---

### **2️⃣ Risk Segmentation & Demographics**  

#### 📊 Risk Category Distribution  
**Chart Type:** Donut / Pie  
**Fields:**  
- Dimension → `risk_category`  
- Metric → `COUNT(user_id)`  
**Insight:** High-risk customers form ~32% but hold disproportionate exposure share.

#### 💰 Exposure by Risk Category  
**Chart Type:** Stacked Bar  
**Fields:**  
- Dimension → `risk_category`  
- Metric → `SUM(exposure)`  
**Insight:** High-risk users show ~3× higher exposure despite similar limits.

#### 👥 Average Risk Score by Age Group  
**Chart Type:** Column Chart  
**Fields:**  
- Dimension → `age_group`  
- Metric → `AVG(risk_score)`  
**Insight:** Risk peaks for ages **18–24** and **55–64**, showing a U-shaped pattern.

#### 🔥 Risk Mix by Age Group  
**Chart Type:** 100% Stacked Bar  
**Fields:**  
- Dimension → `age_group`  
- Breakdown → `risk_category`  
**Insight:** Middle-age groups (35–54) have the highest share of medium-risk users.

#### ⚡ Utilization vs Age  
**Chart Type:** Line  
**Fields:**  
- X-axis → `age_group`  
- Y-axis → `AVG(utilization_ratio)`  
**Insight:** High-risk segments exhibit utilization ratios up to **7× higher** than low-risk cohorts.

---

### **3️⃣ Exposure & Utilization Analysis**
- Heatmap and drill-downs linking utilization, exposure, and risk.  
- Interactive table for exploring customers by risk level and balance.  

---

### **4️⃣ Portfolio Trends & Forecast**

#### 📈 Average Portfolio Risk (ARIMA Forecast)
**Chart Type:** Line (Actual + Forecast)  
**Data:** `risk__avg_risk_arima_forecast`  
**Insight:** Forecast shows steady risk stabilization post–May 2025, confirming portfolio maturity.

#### 👥 Forecasted High-Risk Customer Count  
**Chart Type:** Line  
**Data:** `risk__high_risk_customers_arima_forecast`  
**Insight:** Predicts slight seasonal increase mid-2025, then plateau — key early-warning KPI.

#### 💸 Total Exposure vs Forecasted Risk Score  
**Chart Type:** Combo (Bars = Exposure, Line = Forecasted Risk)  
**Data:** `blended_portfolio_forecast`  
**Insight:** Exposure declines slightly while risk stabilizes → improving **risk-adjusted return**.

---

### **5️⃣ Model Evaluation (ARIMA Metrics)**
**Chart Type:** Table  
**Data Source:** `risk__avg_risk_arima_evaluate`  
**Columns:** `non_seasonal_p`, `d`, `q`, `AIC`, `variance`  
**Insight:** Optimal configuration (2, 0, 0) with lowest AIC ≈ 15.49 → stable and interpretable model.  

---

## 🧠 Key Insights Summary  
✅ Portfolio risk stabilized despite exposure reduction.  
✅ High-risk users are a minority but dominate exposure volume.  
✅ Utilization rate correlates directly with credit risk.  
✅ ARIMA models demonstrate reliable short-term forecasting with low variance.  

---

## 📂 Folder Structure  
```
fintech_dbt/
├── models/
│   ├── staging/
│   ├── core/
│   └── marts/
│       ├── risk/
│       └── time/
├── seeds/
├── analyses/
└── reports/
```

---

## 🚀 How to Run Locally  
```bash
# 1️⃣ Create & activate virtual environment
python3 -m venv .venv
source .venv/bin/activate

# 2️⃣ Install dbt dependencies
pip install dbt-bigquery

# 3️⃣ Run all models
dbt run --full-refresh

# 4️⃣ View Looker dashboard
open https://lookerstudio.google.com/
```

---

## 📈 Next Steps  
- Add segment-level forecasting (by risk category or age_group).  
- Deploy automated daily refresh in BigQuery + dbt Cloud.  
- Integrate anomaly detection for early warning signals.  
