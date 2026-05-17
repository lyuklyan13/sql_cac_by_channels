-- Крок 1 — Дедублікація 
-- залишаємо тільки потрібні метрики для CAC
WITH ranked_snapshots AS (
  SELECT
    source,
    ad_id,
    date,
    spend,
    registrations,
    ROW_NUMBER() OVER(PARTITION BY source, ad_id, date ORDER BY timestamp DESC) AS rnk
  FROM `train-496311.workshop_sql.marketing_ads_raw` 
),

deduped_daily_ads AS (
  SELECT *
  FROM ranked_snapshots
  WHERE rnk = 1
),

-- Крок 2 — Агрегація по місяцях
monthly_metrics AS (
  SELECT
    source,
    -- DATE_TRUNC зрізає день, залишаючи тільки рік та місяць (формат 2024-03-01)
    DATE_TRUNC(date, MONTH) AS report_month,
    SUM(spend) AS monthly_spend,
    SUM(registrations) AS monthly_registrations
  FROM deduped_daily_ads
  GROUP BY 1, 2
)

-- Крок 3 — Розрахунок CAC
SELECT 
  source,
  report_month,
  ROUND(monthly_spend, 2) AS spend,
  monthly_registrations AS registrations,
  ROUND(monthly_spend / NULLIF(monthly_registrations, 0), 2) AS cac
FROM monthly_metrics
ORDER BY source, report_month;
