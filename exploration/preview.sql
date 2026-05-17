-- Таблиця marketing_ads_raw — сирі дані з рекламних кабінетів TikTok, META і Google.


-- Подивитися на декілька рядків даних очима:
SELECT *
FROM train-496311.workshop_sql.marketing_ads_raw
LIMIT 10

-- Розмір таблиці:

SELECT COUNT(*) AS rows_total, COUNT(DISTINCT timestamp ) AS uniq_timestamp
FROM train-496311.workshop_sql.marketing_ads_raw


-- Рахуємо загальний розмір та перевіряємо ієрархію кампаній:

SELECT 
  COUNT(*) AS rows_total,
  COUNT(DISTINCT campaign_id) AS uniq_campaigns,
  COUNT(DISTINCT adset_id) AS uniq_adsets,
  COUNT(DISTINCT ad_id) AS uniq_ads
FROM `train-496311.workshop_sql.marketing_ads_raw`;


-- Схема таблиці:

SELECT *
FROM `train-496311.workshop_sql.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'marketing_ads_raw'


-- Перевірено: чи правильний тип полів, скільки рядків, чи відповідають дані очікуванням.

