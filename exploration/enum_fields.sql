-- Перевіряємо: чи збігаються дані з документацією, чи немає опечаток, помилок, NULL.
-- Всі sources, і скільки кожного

SELECT 
  source,
  COUNT(*) AS cnt
FROM `train-496311.workshop_sql.marketing_ads_raw`
GROUP BY 1
ORDER BY 2 DESC


-- Всі campaigns, і скільки кожного

SELECT 
  campaign_id,
  COUNT(*) AS cnt
FROM `train-496311.workshop_sql.marketing_ads_raw`
GROUP BY 1
ORDER BY 2 DESC;


-- Всі adsets, і скільки кожного

SELECT 
  adset_id,
  COUNT(*) AS cnt
FROM `train-496311.workshop_sql.marketing_ads_raw`
GROUP BY 1
ORDER BY 2 DESC


-- Всі ads, і скільки кожного

SELECT 
  ad_id,
  COUNT(*) AS cnt
FROM `train-496311.workshop_sql.marketing_ads_raw`
GROUP BY 1
ORDER BY  2 DESC


-- Крос: source + campaign_id — скільки записів у кожній комбінації


SELECT
  source,
  campaign_id,
  COUNT(*) AS cnt_records,            
FROM `train-496311.workshop_sql.marketing_ads_raw`
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
