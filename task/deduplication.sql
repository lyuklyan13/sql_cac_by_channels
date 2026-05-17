
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
SELECT * 
FROM  deduped_daily_ads
