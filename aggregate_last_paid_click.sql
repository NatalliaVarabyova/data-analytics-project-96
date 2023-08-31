/* Step3.1. View creation*/

CREATE VIEW last_paid_costs_nv AS
WITH tab AS (
    SELECT
        lp.visitor_id,
        lp.utm_source,
        lp.utm_medium,
        lp.utm_campaign,
        lp.lead_id,
        lp.amount,
        lp.status_id,
        vk.daily_spent AS vk_daily_spent,
        ya.daily_spent AS ya_daily_spent,
        date_trunc('day', lp.visit_date) AS visit_date,
        row_number()
            OVER (PARTITION BY lp.visitor_id ORDER BY lp.visit_date)
        AS rn
    FROM last_paid_nv AS lp
    LEFT JOIN vk_ads AS vk
        ON
            date_trunc('day', lp.visit_date) = vk.campaign_date
            AND lp.utm_source = vk.utm_source
            AND lp.utm_medium = vk.utm_medium
            AND lp.utm_campaign = vk.utm_campaign
            AND lp.utm_content = vk.utm_content
    LEFT JOIN ya_ads AS ya
        ON
            date_trunc('day', lp.visit_date) = ya.campaign_date
            AND lp.utm_source = ya.utm_source
            AND lp.utm_medium = ya.utm_medium
            AND lp.utm_campaign = ya.utm_campaign
            AND lp.utm_content = ya.utm_content
)

SELECT *
FROM tab
WHERE rn = 1;

/* Step 3.2. Data aggregation*/

SELECT
    to_char(visit_date, 'yyyy-mm-dd') AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    count(visitor_id) AS visitors_count,
    sum(CASE
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
ORDER BY 1 ASC, 5 DESC, 2 ASC, 3 ASC, 4 ASC;

/* Step 3.3 Top-15 purchases count selection */

WITH tab AS (
    SELECT
        to_char(visit_date, 'yyyy-mm-dd') AS visit_date,
        utm_source,
        utm_medium,
        utm_campaign,
        count(visitor_id) AS visitors_count,
        sum(CASE
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
    ORDER BY 1 ASC, 5 DESC, 2 ASC, 3 ASC, 4 ASC
)

SELECT *
FROM tab
ORDER BY purchases_count DESC
LIMIT 15;

