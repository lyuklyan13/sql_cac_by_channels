-- Одна з причин неправильних метрик.


-- Null-check: marketing_ads_raw

SELECT 
  COUNTIF(source IS NULL) AS null_source,
  COUNTIF(campaign_id IS NULL) AS null_campaign_id,
  COUNTIF(adset_id IS NULL) AS null_adset_id,
  COUNTIF(ad_id IS NULL) AS null_ad_id,
  COUNTIF(date IS NULL) AS null_date,
  COUNTIF(spend IS NULL) AS null_spend,
  COUNTIF(impressions IS NULL) AS null_impressions,
  COUNTIF(clicks IS NULL) AS null_clicks,
  COUNTIF(installs IS NULL) AS null_installs,
  COUNTIF(registrations IS NULL) AS null_registrations,
  COUNTIF(timestamp IS NULL) AS null_timestamp
FROM `train-496311.workshop_sql.marketing_ads_raw`;


-- Пошук дублікатів записів по оголошеннях

SELECT 
  source,
  ad_id,
  date,
  timestamp,
  COUNT(*) AS cnt
FROM `train-496311.workshop_sql.marketing_ads_raw`
GROUP BY 1, 2, 3, 4
HAVING cnt > 1


-- Швидка перевірка total vs uniq подій для реклами

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT CONCAT(source, '-', ad_id, '-', CAST(timestamp AS STRING))) AS uniq_events
FROM `train-496311.workshop_sql.marketing_ads_raw` 
