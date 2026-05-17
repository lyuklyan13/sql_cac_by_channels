-- Агрегуємо очищені дані по дню і каналу
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

-- Перевірка: загальний spend по каналах має бути
-- ~$15K для TikTok, ~$50K для META, ~$15K для Google
-- Перевірка:

SELECT source, ROUND(SUM(daily_spend), 0) AS total_spend
FROM daily_source_metrics
GROUP BY 1

-- Варто зауважати, що результати вийшли у 100 разів ( загальний spend по каналах )
-- більші ніж у Підказці 
-- Я прискаю, що це помилка у підказці, тому що у випадку
-- spend/100  деякі метрики виглядають анамально: cpm, cac, ltv/cac
