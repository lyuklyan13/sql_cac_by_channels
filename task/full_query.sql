
-- Крок 1 — Дедублікація:
-- Нумеруємо рядки, щоб знайти найновіший запис за день
-- Вибираємо не всі поля - *, а тільки потрібні

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
    -- ROW_NUMBER нумерує записи від найновішого (DESC) до найстарішого
    ROW_NUMBER() OVER(PARTITION BY ad_id, date ORDER BY timestamp DESC) AS rnk
  FROM `train-496311.workshop_sql.marketing_ads_raw` 
),

-- Відфільтровуємо лише останні снепшоти 
deduped_daily_ads AS (
  SELECT *
  FROM ranked_snapshots
  WHERE rnk = 1
),

-- Перевірка:
-- SELECT * 
-- FROM  deduped_daily_ads


-- Крок 2 - Денні метрики:
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

-- SELECT source, ROUND(SUM(daily_spend), 0) AS total_spend
-- FROM daily_source_metrics
-- GROUP BY 1


-- Варто зауважати, що результати вийшли у 100 разів ( загальний spend по каналах )
-- більші ніж у Підказці 
-- Я прискаю, що це помилка у підказці, тому що у випадку
-- spend/100  деякі метрики виглядають анамально: cpm, cac, ltv/cac




-- Крок 3 — Метрики по каналу за весь період:

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





-- Крок 4 - Аналіз:
-- Фінальний розрахунок та оформлення таблиці

SELECT 
  source,
  ROUND(total_spend, 2) AS total_spend,
  ROUND((total_spend / NULLIF(total_impressions, 0)) * 1000, 2) AS cpm,
  ROUND((total_clicks / NULLIF(total_impressions, 0)) * 100, 2) AS ctr_pct,
  ROUND((total_installs / NULLIF(total_clicks, 0)) * 100, 2) AS cr_click_install_pct,
  ROUND((total_registrations / NULLIF(total_installs, 0)) * 100, 2) AS cr_install_reg_pct,
  ROUND(total_spend / NULLIF(total_registrations, 0), 2) AS cac,
  CASE
    WHEN source = 'tiktok' THEN 8.50
    WHEN source = 'meta' THEN 6.20
    WHEN source = 'google' THEN 12.40
  END AS ltv,
  ROUND(
  CASE
      WHEN source = 'tiktok' THEN 8.50
      WHEN source = 'meta' THEN 6.20
      WHEN source = 'google' THEN 12.40
  END / NULLIF((total_spend / NULLIF(total_registrations, 0)), 0), 2) AS ltv_cac
FROM overall_source_metrics
ORDER BY total_spend DESC;



