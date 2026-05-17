-- КРОК 1:
WITH ranked_snapshots AS (
  SELECT
    source,
    ad_id,
    date,
    spend,
    impressions,
    clicks,
    installs,
    registrations,
    ROW_NUMBER() OVER(PARTITION BY ad_id, date ORDER BY timestamp DESC) AS rnk
  FROM `train-496311.workshop_sql.marketing_ads_raw` 
),

-- Відфільтровуємо лише останні снепшоти 
deduped_daily_ads AS (
  SELECT *
  FROM ranked_snapshots
  WHERE rnk = 1
),

-- КРОК 2:
daily_source_metrics AS (
  SELECT
    source,
    date,
    SUM(spend) AS daily_spend,
    SUM(impressions) AS daily_impressions,
    SUM(clicks) AS daily_clicks,
    SUM(installs) AS daily_installs,
    SUM(registrations) AS daily_registrations
  FROM deduped_daily_ads
  GROUP BY 1, 2
),

  
-- КРОК 3:
overall_source_metrics AS (
  SELECT
    source,
    SUM(daily_spend) AS total_spend,
    SUM(daily_impressions) AS total_impressions,
    SUM(daily_clicks) AS total_clicks,
    SUM(daily_installs) AS total_installs,
    SUM(daily_registrations) AS total_registrations
  FROM daily_source_metrics
  GROUP BY 1
)

SELECT *
FROM overall_source_metrics
