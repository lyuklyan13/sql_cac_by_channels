-- Різкі провали по днях = проблема з трекінгом або деплой з багом. 


-- Min / max дата + кількість днів у датасеті
SELECT
  MIN(timestamp) AS earliest,
  MAX(timestamp) AS latest,
  DATE_DIFF(MAX(CAST(date AS DATE)), MIN(CAST(date AS DATE)), DAY) AS days_span
FROM `train-496311.workshop_sql.marketing_ads_raw`;



-- Обсяг записів по днях — шукаємо gaps (прогалини) і аномалії

SELECT
  date AS dt, 
  COUNT(*) AS records_cnt,
  COUNT(DISTINCT ad_id) AS active_ads
FROM `train-496311.workshop_sql.marketing_ads_raw`
GROUP BY 1
ORDER BY 1
