/* Шаг 3.1. Создание view с рекламными расходами */

CREATE VIEW last_paid_costs_nv AS
WITH vk_costs AS (
    SELECT
        campaign_date,
        utm_source,
        utm_medium,
        utm_campaign,
        sum(daily_spent) AS vk_daily_spent
    FROM vk_ads
    GROUP BY 1, 2, 3, 4
),

ya_costs AS (
    SELECT
        campaign_date,
        utm_source,
        utm_medium,
        utm_campaign,
        sum(daily_spent) AS ya_daily_spent
    FROM ya_ads
    GROUP BY 1, 2, 3, 4
)

SELECT
    date_trunc('day', lp.visit_date) AS visit_date
    lp.visitor_id,
    lp.utm_source,
    lp.utm_medium,
    lp.utm_campaign,
    lp.lead_id,
    lp.amount,
    lp.status_id,
    vk.vk_daily_spent,
    ya.ya_daily_spent
FROM last_paid_nv AS lp
LEFT JOIN vk_costs AS vk
    ON
        date_trunc('day', lp.visit_date) = vk.campaign_date
        AND lp.utm_source = vk.utm_source
        AND lp.utm_medium = vk.utm_medium
        AND lp.utm_campaign = vk.utm_campaign
LEFT JOIN ya_costs AS ya
    ON
        date_trunc('day', lp.visit_date) = ya.campaign_date
        AND lp.utm_source = ya.utm_source
        AND lp.utm_medium = ya.utm_medium
        AND lp.utm_campaign = ya.utm_campaign;


/* Шаг 3.2. Агрегация данных */

SELECT
    to_char(visit_date, 'yyyy-mm-dd') AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    count(visitor_id) AS visitors_count,
   max(CASE
        WHEN vk_daily_spent IS NOT NULL THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT NULL THEN ya_daily_spent
        ELSE 0
    END) AS total_cost,
    count(lead_id) AS leads_count,
    sum(CASE
        WHEN status_id = 142 THEN 1
        ELSE 0
    END) AS purchases_count,
    sum(CASE
        WHEN status_id = 142 THEN coalesce(amount, 0)
    END) AS revenue
FROM last_paid_costs_nv
GROUP BY 1, 2, 3, 4
ORDER BY 9 DESC NULLS LAST, 1 ASC, 5 DESC, 2 ASC, 3 ASC, 4 ASC

/* Шаг 3.3. 15 кампаний, принёсших наибольшее количество продаж. */

WITH tab AS (
    SELECT
        to_char(visit_date, 'yyyy-mm-dd') AS visit_date,
        utm_source,
        utm_medium,
        utm_campaign,
        count(visitor_id) AS visitors_count,
        max(CASE
            WHEN vk_daily_spent IS NOT NULL THEN vk_daily_spent
            WHEN ya_daily_spent IS NOT NULL THEN ya_daily_spent
            ELSE 0
        END) AS total_cost,
        count(lead_id) AS leads_count,
        sum(CASE
            WHEN status_id = 142 THEN 1
            ELSE 0
        END) AS purchases_count,
        sum(CASE
            WHEN status_id = 142 THEN coalesce(amount, 0)
        END) AS revenue
    FROM last_paid_costs_nv
    GROUP BY 1, 2, 3, 4
    ORDER BY 9 DESC NULLS LAST, 1 ASC, 5 DESC, 2 ASC, 3 ASC, 4 ASC
)

SELECT *
FROM tab
ORDER BY purchases_count DESC
LIMIT 15;
