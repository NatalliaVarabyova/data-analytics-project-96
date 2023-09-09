/* Дашборд Шаг 4.7. Расчёт количества посетителей сайта по source / medium / campaign по дням. Файл daily_visitors_count_from_campaign.csv */

SELECT
    to_char(visit_date, 'YYYY-MM-DD') :: DATE AS visit_date,
    source,
    medium,
    campaign,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
ORDER BY 4 ASC, 5 DESC;

/* Дашборд Шаг 4. Расчёт количества посетителей по источникам (объединённые) за месяц. для выявления наибольших источников*/

WITH tab AS (
    SELECT
        source,
        count(DISTINCT visitor_id) AS visitors_count
    FROM sessions
    GROUP BY 1
),

tab2 AS (
    SELECT
        *,
        ntile(16) OVER (ORDER BY visitors_count) AS nt
    FROM tab
),

tab3 AS (
    SELECT
        CASE
            WHEN nt < 15 THEN 'other'
            ELSE "source"
        END AS "source",
        sum(visitors_count) AS visitors_count
    FROM tab2
    GROUP BY "source", nt
)

SELECT
    "source",
    sum(visitors_count)
FROM tab3
GROUP BY 1
ORDER BY 2 DESC;

/* Дашборд Шаг 4. Расчёт количества посетителей по источникам, принёсших наибольшее количество посетителей */

SELECT
    date_trunc('day', visit_date) AS visit_date,
    CASE
        WHEN source IN ('google', 'organic', 'yandex', 'vk') THEN "source"
        ELSE 'other'
    END AS "source",
    medium,
    campaign,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
ORDER BY 1 ASC, 5 DESC;


/* Дашборд Шаг 4. Расчёт количества посетителей за месяц по источникам, принёсшим наименьшее количество посетителей */

SELECT
    date_trunc('day', visit_date) AS visit_date,
    source,
    medium,
    campaign,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
HAVING "source" NOT IN ('google', 'organic', 'yandex', 'vk')
ORDER BY 1 ASC, 5 DESC;

/* Дашборд Шаг 4. Подготовка данных для воронки (пользователь - лид - клиент)*/

WITH cte AS (
    SELECT
        date_trunc('day', visit_date) AS visit_date,
        utm_source,
        utm_medium,
        utm_campaign,
        count(visitor_id) AS visitors_count,
        count(lead_id) AS leads_count,
        sum(CASE
            WHEN status_id = 142 THEN 1
            ELSE 0
        END) AS purchases_count
    FROM last_paid_costs_nv
    GROUP BY 1, 2, 3, 4
)

SELECT
    t.*,
    visit_date,
    utm_source,
    utm_medium,
    utm_campaign
FROM cte AS c
CROSS JOIN LATERAL (
    VALUES
    (c.visitors_count, '1 - Посетитель'),
    (c.leads_count, '2 - Лид'),
    (c.purchases_count, '3 - Клиент')
) AS t (turnover, funnel_metric)
ORDER BY
    visit_date,
    utm_source,
    utm_medium,
    utm_campaign, funnel_metric;


/* Дашборд Шаг 4.12 Расчёт коэффициента липучести. Файл sticky_factor.csv */

WITH mau AS (
    SELECT count(DISTINCT visitor_id) AS mau
    FROM sessions
),

pre_dau AS (
    SELECT
        date_trunc('day', visit_date) AS visit_date,
        count(DISTINCT visitor_id) AS daily_visitor_count
    FROM sessions
    GROUP BY 1
),

dau AS (
    SELECT
        percentile_cont(0.5) WITHIN GROUP (ORDER BY daily_visitor_count) AS dau
    FROM pre_dau
)

SELECT round(dau.dau :: INTEGER * 100.0 / mau.mau, 2) AS sticky_factor
FROM dau, mau;

/* Дашборд Шаг 4.19. Расчёт количества лидов по source / medium / campaign по дням. Файл daily_leads_count_from_campaign.csv */

SELECT
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,
    date_trunc('day', l.created_at) AS visit_date,
    count(l.lead_id) AS leads_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3, 4
ORDER BY 4 ASC, 5 DESC;

/* Дашборд Шаг 4.31. Расчёт расходов на рекламу в динамике по source / medium / campaign. Файл ad_costs_campaign.csv */

SELECT
    date_trunc('day', campaign_date) AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    sum(daily_spent) AS ad_costs
FROM vk_ads
GROUP BY 1, 2, 3, 4
UNION
SELECT
    date_trunc('day', campaign_date) AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    sum(daily_spent) AS ad_costs
FROM ya_ads
GROUP BY 1, 2, 3, 4
ORDER BY 1, 2, 3, 4;

/* Дашборд Шаг 4.37. Расчёт CPU по дням по атрибуции last paid click по source / medium / campaign. Файл daily_cpu_campaign.scv */

SELECT
    date_trunc('day', visit_date) AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    round(max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END) * 1.0 / count(DISTINCT visitor_id), 2) AS cpu
FROM last_paid_costs_nv
GROUP BY 1, 2, 3, 4
HAVING
    max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END) > 0
ORDER BY 1 ASC, 5 DESC;

/* Дашборд Шаг 4.43. Расчёт CPL по дням по атрибуции last paid click по source / medium / campaign. Файл daily_cpl_campaign.scv */

SELECT
    date_trunc('day', visit_date) AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    round(max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END) * 1.0 / (count(DISTINCT lead_id)), 2) AS cpl
FROM last_paid_costs_nv
GROUP BY 1, 2, 3, 4
HAVING
    count(DISTINCT lead_id) > 0
    AND max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END) > 0
ORDER BY 1 ASC, 5 DESC;

/* Дашборд Шаг 4.49. Расчёт CPPU по дням по атрибуции last paid click по source / medium / campaign. Файл daily_cppu_campaign.scv */

SELECT
    date_trunc('day', visit_date) AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    round(max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END) * 1.0 / sum(CASE
        WHEN status_id = 142 THEN 1
        ELSE 0
    END), 2) AS cppu
FROM last_paid_costs_nv
GROUP BY 1, 2, 3, 4
HAVING
    sum(CASE
        WHEN status_id = 142 THEN 1
        ELSE 0
    END) > 0
    AND max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END) > 0
ORDER BY 5 DESC;

/* Дашборд Шаг 4.55. Расчёт ROI по дням по атрибуции last paid click по source / medium / campaign. Файл daily_roi_campaign.scv */

SELECT
    date_trunc('day', visit_date) AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    round((sum(CASE
        WHEN status_id = 142 THEN coalesce(amount, 0)
    END) - max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END)) * 100.0 / max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END), 2) AS roi
FROM last_paid_costs_nv
GROUP BY 1, 2, 3, 4
HAVING
    max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END) > 0
ORDER BY 1 ASC, 5 DESC NULLS LAST;
