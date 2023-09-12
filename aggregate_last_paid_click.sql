/* Шаг 3.1. Создание view с рекламными расходами */

CREATE VIEW last_paid_costs_nv AS
WITH costs AS (
    SELECT
        campaign_date,
        utm_source,
        utm_medium,
        utm_campaign,
        sum(daily_spent) AS daily_spent
    FROM vk_ads
    GROUP BY 1, 2, 3, 4
    UNION ALL
    SELECT
        campaign_date,
        utm_source,
        utm_medium,
        utm_campaign,
        sum(daily_spent) AS daily_spent
    FROM ya_ads
    GROUP BY 1, 2, 3, 4
)

SELECT
    to_char(lp.visit_date, 'YYYY-MM-DD')::date AS visit_date,
    lp.visitor_id,
    lp.utm_source,
    lp.utm_medium,
    lp.utm_campaign,
    lp.lead_id,
    lp.amount,
    lp.status_id,
    c.daily_spent
FROM last_paid_nv AS lp
LEFT JOIN costs AS c
    ON
        date_trunc('day', lp.visit_date) = c.campaign_date
        AND lp.utm_source = c.utm_source
        AND lp.utm_medium = c.utm_medium
        AND lp.utm_campaign = c.utm_campaign;

/* Шаг 3.2. Агрегация данных */

SELECT
    to_char(visit_date, 'YYYY-MM-DD')::date AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    count(visitor_id) AS visitors_count,
    max(daily_spent) AS total_cost,
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
ORDER BY 9 DESC NULLS LAST, 1 ASC, 5 DESC, 2 ASC, 3 ASC, 4 ASC;

/* Шаг 3.3. 15 кампаний, принёсших наибольшее количество продаж. */

SELECT
    to_char(visit_date, 'YYYY-MM-DD')::date AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    count(visitor_id) AS visitors_count,
    max(daily_spent) AS total_cost,
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
LIMIT 15;
