/* Шаг 4.1. Расчёт количества посетителей сайта по дням. Файл daily_visitors_count.csv */

SELECT
    to_char(visit_date, 'YYYY-MM-DD') AS visit_date,
    count(DISTINCT visitor_id) AS daily_visitor_count
FROM sessions
GROUP BY 1
ORDER BY 1;

/* Шаг 4.2. Расчёт количества посетителей сайта в неделю. Файл weekly_visitors_count.csv*/

SELECT
    CASE
        WHEN to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-07' THEN '1 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-08'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-14'
            THEN '2 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-15'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-21'
            THEN '3 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-22'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-28'
            THEN '4 неделя'
        ELSE '5 неделя (2 дня)'
    END AS week_of_june,
    count(DISTINCT visitor_id) AS weekly_visitors_count
FROM sessions
GROUP BY 1;

/* Шаг 4.3. Расчёт количества посетителей сайта по источникам за июнь. Файл source_visitors_count.csv */

SELECT
    source,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1
ORDER BY 2 DESC;

/* Шаг 4.4. Расчёт количества посетителей сайта по источникам по дням. Файл daily_visitors_count_from_source.csv */

SELECT
    source,
    to_char(visit_date, 'YYYY-MM-DD') AS visit_date,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2
ORDER BY 2 ASC, 3 DESC;

/* Шаг 4.5. Расчёт количества посетителей сайта по источникам в неделю. Файл weekly_visitors_count_from_source.csv */

SELECT
    source,
    CASE
        WHEN to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-07' THEN '1 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-08'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-14'
            THEN '2 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-15'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-21'
            THEN '3 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-22'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-28'
            THEN '4 неделя'
        ELSE '5 неделя (2 дня)'
    END AS week_of_june,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2
ORDER BY 2 ASC, 3 DESC;

/* Шаг 4.6. Расчёт количества посетителей сайта по source / medium / campaign за июнь. Файл daily_visitors_count_from_campaign.csv */

SELECT
    source,
    medium,
    campaign,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3
ORDER BY 4 DESC;

/* Шаг 4.7. Расчёт количества посетителей сайта по source / medium / campaign по дням. Файл daily_visitors_count_from_campaign.csv */

SELECT
    source,
    medium,
    campaign,
    to_char(visit_date, 'YYYY-MM-DD') AS visit_date,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
ORDER BY 4 ASC, 5 DESC;

/* Шаг 4.8. Расчёт количества посетителей сайта по source / medium / campaign в неделю. Файл weekly_visitors_count_from_campaign.csv */

SELECT
    source,
    medium,
    campaign,
    CASE
        WHEN to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-07' THEN '1 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-08'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-14'
            THEN '2 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-15'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-21'
            THEN '3 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-22'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-28'
            THEN '4 неделя'
        ELSE '5 неделя (2 дня)'
    END AS week_of_june,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
ORDER BY 4 ASC, 5 DESC;

/* Шаг 4.9. Расчёт количества посетителей сайта по source / medium за июнь. Файл monthly_visitors_count_from_medium.csv */

SELECT
    source,
    CASE
        WHEN lower(medium) = 'organic' THEN lower(medium)
        ELSE 'paid'
    END AS medium,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2
ORDER BY 3 DESC;

/* Шаг 4.10. Расчёт количества посетителей сайта по source / medium по дням. Файл daily_visitors_count_from_medium.csv */

SELECT
    source,
    CASE
        WHEN lower(medium) = 'organic' THEN lower(medium)
        ELSE 'paid'
    END AS medium,
    to_char(visit_date, 'YYYY-MM-DD') AS visit_date,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3
ORDER BY 3 ASC, 4 DESC;

/* Шаг 4.11. Расчёт количества посетителей сайта по source / medium в неделю. Файл weekly_visitors_count_from_medium.csv */

SELECT
    source,
    CASE
        WHEN lower(medium) = 'organic' THEN lower(medium)
        ELSE 'paid'
    END AS medium,
    CASE
        WHEN to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-07' THEN '1 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-08'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-14'
            THEN '2 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-15'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-21'
            THEN '3 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-22'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-28'
            THEN '4 неделя'
        ELSE '5 неделя (2 дня)'
    END AS week_of_june,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3
ORDER BY 3 ASC, 4 DESC;

/* Шаг 4.12 Расчёт коэффициента липучести. Файл sticky_factor.csv */

WITH mau AS (
    SELECT count(DISTINCT visitor_id) AS mau
    FROM sessions
),

pre_dau AS (
    SELECT
        to_char(visit_date, 'YYYY-MM-DD') AS visit_date,
        count(DISTINCT visitor_id) AS daily_visitor_count
    FROM sessions
    GROUP BY 1
),

dau AS (
    SELECT
        percentile_cont(0.5) WITHIN GROUP (ORDER BY daily_visitor_count) AS dau
    FROM pre_dau
)

SELECT dau.dau * 100.0 / mau.mau AS sticky_factor
FROM dau, mau;


/* Шаг 4.13. Расчёт количества лидов по дням. Файл daily_leads_count.csv */

SELECT
    to_char(created_at, 'YYYY-MM-DD') AS created_at,
    count(lead_id) AS leads_count
FROM leads
GROUP BY 1
ORDER BY 1;

/* Шаг 4.14 Расчёт количества лидов в неделю. Файл weekly_leads_count.csv*/

SELECT
    CASE
        WHEN to_char(created_at, 'YYYY-MM-DD') <= '2023-06-07' THEN '1 неделя'
        WHEN
            to_char(created_at, 'YYYY-MM-DD') >= '2023-06-08'
            AND to_char(created_at, 'YYYY-MM-DD') <= '2023-06-14'
            THEN '2 неделя'
        WHEN
            to_char(created_at, 'YYYY-MM-DD') >= '2023-06-15'
            AND to_char(created_at, 'YYYY-MM-DD') <= '2023-06-21'
            THEN '3 неделя'
        WHEN
            to_char(created_at, 'YYYY-MM-DD') >= '2023-06-22'
            AND to_char(created_at, 'YYYY-MM-DD') <= '2023-06-28'
            THEN '4 неделя'
        ELSE '5 неделя (2 дня)'
    END AS week_of_june,
    count(lead_id) AS leads_count
FROM leads
GROUP BY 1
ORDER BY 1 ASC;

/* Шаг 4.15. Расчёт количества лидов по источникам за июнь. Файл monthly_leads_count_from_source.csv */

SELECT
    s.source,
    count(l.lead_id) AS leads_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1
ORDER BY 2 DESC;

/* Шаг 4.16. Расчёт количества лидов по источникам по дням. Файл daily_leads_count_from_source.csv */

SELECT
    s.source,
    to_char(l.created_at, 'YYYY-MM-DD') AS created_at,
    count(l.lead_id) AS leads_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2
ORDER BY 2 ASC, 3 DESC;

/* Шаг 4.17. Расчёт количества лидов по источникам в неделю. Файл weekly_leads_count_from_source.csv */

SELECT
    s.source,
    CASE
        WHEN to_char(l.created_at, 'YYYY-MM-DD') <= '2023-06-07' THEN '1 неделя'
        WHEN
            to_char(l.created_at, 'YYYY-MM-DD') >= '2023-06-08'
            AND to_char(l.created_at, 'YYYY-MM-DD') <= '2023-06-14'
            THEN '2 неделя'
        WHEN
            to_char(l.created_at, 'YYYY-MM-DD') >= '2023-06-15'
            AND to_char(l.created_at, 'YYYY-MM-DD') <= '2023-06-21'
            THEN '3 неделя'
        WHEN
            to_char(l.created_at, 'YYYY-MM-DD') >= '2023-06-22'
            AND to_char(l.created_at, 'YYYY-MM-DD') <= '2023-06-28'
            THEN '4 неделя'
        ELSE '5 неделя (2 дня)'
    END AS week_of_june,
    count(l.lead_id) AS leads_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2
ORDER BY 2 ASC, 3 DESC;

/* Шаг 4.18. Расчёт количества лидов по source / medium / campaign за июнь. Файл monthly_leads_count_from_campaign.csv */

SELECT
    s.source,
    s.medium,
    s.campaign,
    count(l.lead_id) AS leads_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC;

/* Шаг 4.19. Расчёт количества лидов по source / medium / campaign по дням. Файл daily_leads_count_from_campaign.csv */

SELECT
    s.source,
    s.medium,
    s.campaign,
    to_char(l.created_at, 'YYYY-MM-DD') AS created_at,
    count(l.lead_id) AS leads_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3, 4
ORDER BY 4 ASC, 5 DESC;

/* Шаг 4.20. Расчёт количества лидов по source / medium / campaign в неделю. Файл weekly_leads_count_from_campaign.csv */

SELECT
    s.source,
    s.medium,
    s.campaign,
    CASE
        WHEN to_char(l.created_at, 'YYYY-MM-DD') <= '2023-06-07' THEN '1 неделя'
        WHEN
            to_char(l.created_at, 'YYYY-MM-DD') >= '2023-06-08'
            AND to_char(l.created_at, 'YYYY-MM-DD') <= '2023-06-14'
            THEN '2 неделя'
        WHEN
            to_char(l.created_at, 'YYYY-MM-DD') >= '2023-06-15'
            AND to_char(l.created_at, 'YYYY-MM-DD') <= '2023-06-21'
            THEN '3 неделя'
        WHEN
            to_char(l.created_at, 'YYYY-MM-DD') >= '2023-06-22'
            AND to_char(l.created_at, 'YYYY-MM-DD') <= '2023-06-28'
            THEN '4 неделя'
        ELSE '5 неделя (2 дня)'
    END AS week_of_june,
    count(l.lead_id) AS leads_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3, 4
ORDER BY 4 ASC, 5 DESC;

/* Шаг 4.21. Расчёт количества лидов по source / medium за июнь. Файл monthly_leads_count_from_medium.csv */

SELECT
    s.source,
    CASE
        WHEN lower(s.medium) = 'organic' THEN lower(s.medium)
        ELSE 'paid'
    END AS medium,
    count(l.lead_id) AS leads_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2
ORDER BY 3 DESC;

/* Шаг 4.22. Расчёт количества лидов по source / medium по дням. Файл daily_leads_count_from_medium.csv */

SELECT
    s.source,
    CASE
        WHEN lower(s.medium) = 'organic' THEN lower(s.medium)
        ELSE 'paid'
    END AS medium,
    to_char(l.created_at, 'YYYY-MM-DD') AS created_at,
    count(l.lead_id) AS leads_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3
ORDER BY 3 ASC, 4 DESC;

/* Шаг 4.23. Расчёт количества лидов по source / medium в неделю. Файл weekly_leads_count_from_medium.csv */

SELECT
    s.source,
    CASE
        WHEN lower(s.medium) = 'organic' THEN lower(s.medium)
        ELSE 'paid'
    END AS medium,
    CASE
        WHEN to_char(l.created_at, 'YYYY-MM-DD') <= '2023-06-07' THEN '1 неделя'
        WHEN
            to_char(l.created_at, 'YYYY-MM-DD') >= '2023-06-08'
            AND to_char(l.created_at, 'YYYY-MM-DD') <= '2023-06-14'
            THEN '2 неделя'
        WHEN
            to_char(l.created_at, 'YYYY-MM-DD') >= '2023-06-15'
            AND to_char(l.created_at, 'YYYY-MM-DD') <= '2023-06-21'
            THEN '3 неделя'
        WHEN
            to_char(l.created_at, 'YYYY-MM-DD') >= '2023-06-22'
            AND to_char(l.created_at, 'YYYY-MM-DD') <= '2023-06-28'
            THEN '4 неделя'
        ELSE '5 неделя (2 дня)'
    END AS week_of_june,
    count(l.lead_id) AS leads_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3
ORDER BY 3 ASC, 4 DESC;

/* Шаг 4.24. Расчёт конверсии из клика в лид по source. Файл lcr_from_source.csv */

SELECT
    s.source,
    round(count(l.lead_id) * 100.00 / count(s.visitor_id), 2) AS lcr
FROM sessions AS s
LEFT JOIN leads AS l
    ON
        s.visitor_id = l.visitor_id
        AND s.visit_date <= l.created_at
GROUP BY 1
ORDER BY 2 DESC;

/* Шаг 4.25. Расчёт конверсии из клика в лид по source / medium. Файл lcr_from_medium.csv */

SELECT
    s.source,
    s.medium,
    round(count(l.lead_id) * 100.00 / count(s.visitor_id), 2) AS lcr
FROM sessions AS s
LEFT JOIN leads AS l
    ON
        s.visitor_id = l.visitor_id
        AND s.visit_date <= l.created_at
GROUP BY 1, 2
ORDER BY 3 DESC;

/* Шаг 4.26. Расчёт конверсии из клика в лид по source / medium / campaign. Файл lcr_from_campaign.csv */

SELECT
    s.source,
    s.medium,
    s.campaign,
    round(count(l.lead_id) * 100.00 / count(s.visitor_id), 2) AS lcr
FROM sessions AS s
LEFT JOIN leads AS l
    ON
        s.visitor_id = l.visitor_id
        AND s.visit_date <= l.created_at
GROUP BY 1, 2, 3
ORDER BY 4 DESC;

/* Шаг 4.27. Расчёт конверсии из лида в клиента по source. Файл lead_client_from_source.csv */

SELECT
    s.source,
    round(
        sum(CASE WHEN l.status_id = 142 THEN 1 ELSE 0 END)
        * 100.00
        / count(l.lead_id),
        2
    ) AS lead_to_client_rate
FROM sessions AS s
LEFT JOIN leads AS l
    ON
        s.visitor_id = l.visitor_id
        AND s.visit_date <= l.created_at
GROUP BY 1
HAVING count(l.lead_id) > 0
ORDER BY 2 DESC;


/* Шаг 4.28. Расчёт конверсии из лида в клиента по source / medium. Файл lead_client_from_medium.csv */

SELECT
    s.source,
    s.medium,
    round(
        sum(CASE WHEN l.status_id = 142 THEN 1 ELSE 0 END)
        * 100.00
        / count(l.lead_id),
        2
    ) AS lead_to_client_rate
FROM sessions AS s
LEFT JOIN leads AS l
    ON
        s.visitor_id = l.visitor_id
        AND s.visit_date <= l.created_at
GROUP BY 1, 2
HAVING count(l.lead_id) > 0
ORDER BY 3 DESC;

/* Шаг 4.29. Расчёт конверсии из лида в клиента по source / medium. Файл lead_client_from_campaign.csv */

SELECT
    s.source,
    s.medium,
    s.campaign,
    round(
        sum(CASE WHEN l.status_id = 142 THEN 1 ELSE 0 END)
        * 100.00
        / count(l.lead_id),
        2
    ) AS lead_to_client_rate
FROM sessions AS s
LEFT JOIN leads AS l
    ON
        s.visitor_id = l.visitor_id
        AND s.visit_date <= l.created_at
GROUP BY 1, 2, 3
HAVING count(l.lead_id) > 0
ORDER BY 4 DESC;

/* Шаг 4.30. Расчёт расходов на рекламу в динамике. Файл ad_costs.csv */

WITH vk_costs AS (
    SELECT
        to_char(campaign_date, 'YYYY-MM-DD') AS campaign_date,
        sum(daily_spent) AS vk_costs
    FROM vk_ads
    GROUP BY 1
),

ya_costs AS (
    SELECT
        to_char(campaign_date, 'YYYY-MM-DD') AS campaign_date,
        sum(daily_spent) AS ya_costs
    FROM ya_ads
    GROUP BY 1
)

SELECT
    vk_costs.campaign_date,
    vk_costs.vk_costs,
    ya_costs.ya_costs,
    vk_costs.vk_costs + ya_costs.ya_costs AS total_costs
FROM vk_costs
LEFT JOIN ya_costs
    ON vk_costs.campaign_date = ya_costs.campaign_date
ORDER BY 1;

/* Шаг 4.31. Расчёт расходов на рекламу в динамике по source / medium / campaign. Файл ad_costs_campaign.csv */

SELECT
    to_char(campaign_date, 'YYYY-MM-DD') AS campaign_date,
    utm_source,
    utm_medium,
    utm_campaign,
    sum(daily_spent) AS vk_costs
FROM vk_ads
GROUP BY 1, 2, 3, 4
UNION
SELECT
    to_char(campaign_date, 'YYYY-MM-DD') AS campaign_date,
    utm_source,
    utm_medium,
    utm_campaign,
    sum(daily_spent) AS ya_costs
FROM ya_ads
GROUP BY 1, 2, 3, 4
ORDER BY 1, 2, 3, 4;

/* Шаг 4.32. Расчёт CPU по атрибуции last paid click. Файл monthly_cpu.scv */

SELECT
    max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END) * 1.0 / count(DISTINCT visitor_id) AS monthly_cpu
FROM last_paid_costs_nv;

/* Шаг 4.33. Расчёт CPU по неделям по атрибуции last paid click. Файл weekly_cpu.scv */

SELECT
    CASE
        WHEN to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-07' THEN '1 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-08'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-14'
            THEN '2 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-15'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-21'
            THEN '3 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-22'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-28'
            THEN '4 неделя'
        ELSE '5 неделя (2 дня)'
    END AS week_of_june,
    max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END) * 1.0 / count(DISTINCT visitor_id) AS cpu
FROM last_paid_costs_nv
GROUP BY 1;

/* Шаг 4.34. Расчёт CPU по дням по атрибуции last paid click. Файл daily_cpu.scv */

SELECT
    to_char(visit_date, 'YYYY-MM-DD') AS visit_date,
    max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END) * 1.0 / count(DISTINCT visitor_id) AS cpu
FROM last_paid_costs_nv
GROUP BY 1
ORDER BY 1;

/* Шаг 4.35. Расчёт CPL по атрибуции last paid click. Файл monthly_cpl.scv */

SELECT
    max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END) * 1.0 / count(DISTINCT lead_id) AS monthly_cpl
FROM last_paid_costs_nv;

/* Шаг 4.36. Расчёт CPL по неделям по атрибуции last paid click. Файл weekly_cpl.scv */

SELECT
    CASE
        WHEN to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-07' THEN '1 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-08'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-14'
            THEN '2 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-15'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-21'
            THEN '3 неделя'
        WHEN
            to_char(visit_date, 'YYYY-MM-DD') >= '2023-06-22'
            AND to_char(visit_date, 'YYYY-MM-DD') <= '2023-06-28'
            THEN '4 неделя'
        ELSE '5 неделя (2 дня)'
    END AS week_of_june,
    round(max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END) * 1.0 / count(DISTINCT lead_id), 2) AS cpl
FROM last_paid_costs_nv
GROUP BY 1;

/* Шаг 4.37. Расчёт CPL по дням по атрибуции last paid click. Файл daily_cpl.scv */

SELECT
    to_char(visit_date, 'YYYY-MM-DD') AS visit_date,
    round(max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END) * 1.0 / (count(DISTINCT lead_id)), 2) AS cpl
FROM last_paid_costs_nv
GROUP BY 1
HAVING count(DISTINCT lead_id) > 0
ORDER BY 1;


