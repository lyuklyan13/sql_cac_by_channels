-- Перевірка базової статистики для числових полів (аномалії, мінусові значення, викиди)

SELECT
  -- Статистика по витратах (spend)
  MIN(spend) AS min_spend,
  MAX(spend) AS max_spend,
  AVG(spend) AS avg_spend,
  APPROX_QUANTILES(spend, 100)[OFFSET(50)] AS median_spend,
  
  -- Статистика по показах (impressions)
  MIN(impressions) AS min_imp,
  MAX(impressions) AS max_imp,
  APPROX_QUANTILES(impressions, 100)[OFFSET(50)] AS median_imp,

  -- Статистика по кліках (clicks)
  MIN(clicks) AS min_clicks,
  MAX(clicks) AS max_clicks,
  APPROX_QUANTILES(clicks, 100)[OFFSET(50)] AS median_clicks,

  -- Статистика по установках (installs)
  MIN(installs) AS min_installs,
  MAX(installs) AS max_installs,
  APPROX_QUANTILES(installs, 100)[OFFSET(50)] AS median_installs

FROM `train-496311.workshop_sql.marketing_ads_raw`;


-- Пошук аномальних значень у маркетингових даних
SELECT
  -- Перевірка витрат (spend)
  COUNTIF(spend = 0) AS zero_spend,
  COUNTIF(spend < 0) AS negative_spend,
  COUNTIF(spend > 5000) AS outlier_spend,
  
  -- Перевірка показів (impressions)
  COUNTIF(impressions = 0) AS zero_impressions,
  COUNTIF(impressions < 0) AS negative_impressions
FROM `train-496311.workshop_sql.marketing_ads_raw`;


-- Статистика витрат (spend) у розрізі рекламних джерел
SELECT
  source,
  COUNT(*) AS records_cnt,
  ROUND(AVG(spend), 2) AS avg_spend,
  ROUND(MIN(spend), 2) AS min_spend,
  ROUND(MAX(spend), 2) AS max_spend
FROM `train-496311.workshop_sql.marketing_ads_raw`
GROUP BY 1;



-- Перевірка чи дійсно суми є строго накопичувальними (чи немає падінь метрик протягом дня)
WITH lagged_data AS (
  SELECT
    ad_id,
    date,
    timestamp,
    spend,
    LAG(spend) OVER(PARTITION BY ad_id, date ORDER BY timestamp) AS prev_spend,
    impressions,
    LAG(impressions) OVER(PARTITION BY ad_id, date ORDER BY timestamp) AS prev_impressions
  FROM `train-496311.workshop_sql.marketing_ads_raw`
)

SELECT
  COUNTIF(spend < prev_spend) AS spend_drops_count,
  COUNTIF(impressions < prev_impressions) AS impressions_drops_count
FROM lagged_data;
