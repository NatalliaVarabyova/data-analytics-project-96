/* Шаг 4.1. Расчёт количества посетителей сайта по source / medium / campaign по дням.
Дашборд: Количество пользователей из всех источников. */

SELECT
    date_trunc('day', visit_date) AS visit_date,
    source AS utm_source,
    medium AS utm_medium,
    campaign AS utm_campaign,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
ORDER BY 1 ASC, 5 DESC;

/* Шаг 4.2. Расчёт количества посетителей по источникам (объединённые) за месяц
(для выявления наибольших источников). Дашборд: Количество пользователей по источникам. */

SELECT
    source,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1
ORDER BY 2 DESC;

/* Шаг 4.3. Расчёт количества посетителей по источникам, принёсших наибольшее количество посетителей.
Дашборд: Количество пользователей по источникам. */

WITH tab AS (
    SELECT
        source,
        count(DISTINCT visitor_id) AS visitors_count
    FROM sessions
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 4
)

SELECT
    date_trunc('day', visit_date) AS visit_date,
    CASE
        WHEN source IN (SELECT source FROM tab) THEN source
        ELSE 'other'
    END AS utm_source,
    medium AS utm_medium,
    campaign AS utm_campaign,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
ORDER BY 1 ASC, 5 DESC;

/* Шаг 4.4. Расчёт количества посетителей сайта по бесплатным источникам (google, organic).
Дашборд: Количество пользователей по прямым переходам из google и organic. */

WITH tab AS (
    SELECT
        date_trunc('day', visit_date) AS visit_date,
        source AS utm_source,
        medium AS utm_medium,
        count(DISTINCT visitor_id) AS visitors_count
    FROM sessions
    GROUP BY 1, 2, 3
    HAVING medium LIKE '%organic%'
)

SELECT
    visit_date,
    utm_source,
    sum(visitors_count) AS visitors_count
FROM tab
GROUP BY 1, 2
HAVING utm_source IN ('google', 'organic')
ORDER BY 1 ASC, 3 DESC;

/* Шаг 4.5. Расчёт количества посетителей сайта по другим бесплатным источникам (кроме google, organic).
Дашборд: Количество пользователей из других бесплатных источников (кроме google и organic). */

WITH tab AS (
    SELECT
        to_char(visit_date, 'YYYY-MM-DD')::date AS visit_date,
        source AS utm_source,
        medium AS utm_medium,
        count(DISTINCT visitor_id) AS visitors_count
    FROM sessions
    GROUP BY 1, 2, 3
    HAVING medium LIKE '%organic%'
)

SELECT
    visit_date,
    utm_source,
    sum(visitors_count) AS visitors_count
FROM tab
GROUP BY 1, 2
HAVING utm_source NOT IN ('google', 'organic')
ORDER BY 1 ASC, 3 DESC;

/* Шаг 4.6. Расчёт количества посетителей сайта по vk и yandex. Дашборды: Количество пользователей из vk и yandex (платные каналы),
Количество пользователей из vk по типу рекламной компании, Количество пользователей из yandex по рекламным кампаниям. */

SELECT
    to_char(visit_date, 'YYYY-MM-DD')::date AS visit_date,
    source AS utm_source,
    medium AS utm_medium,
    campaign AS utm_campaign,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
HAVING source IN ('vk', 'yandex')
ORDER BY 5 DESC;

/* Шаг 4.7. Расчёт количества посетителей сайта по другим источникам (кроме organic, vk, yandex)
Дашборд: Количество пользователей из других источников (кроме organic, vk и yandex). */

SELECT
    to_char(visit_date, 'YYYY-MM-DD')::date AS visit_date,
    source AS utm_source,
    medium AS utm_medium,
    campaign AS utm_campaign,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
HAVING medium NOT LIKE '%organic%' AND source NOT IN ('vk', 'yandex')
ORDER BY 5 DESC;

/* Шаг 4.8. Расчёт коэффициента липучести. Дашборд: Коэффициент липучести. */

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

/* Шаг 4.9. Расчёт количества лидов по source / medium / campaign по дням. Дашборд: Количество лидов из всех источников. */

SELECT
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,
    date_trunc('day', l.created_at) AS visit_date,
    count(l.lead_id) AS lead_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3, 4
ORDER BY 4 ASC;


/* Шаг 4.10. Расчёт количества лидов по источникам, принёсших наибольшее количество пользователей.
Дашборд: Количество лидов по источникам.  */

WITH tab AS (
    SELECT
        source,
        count(DISTINCT visitor_id) AS visitors_count
    FROM sessions
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 4
)

SELECT
    date_trunc('day', l.created_at) AS visit_date,
    CASE
        WHEN s.source IN (SELECT source FROM tab) THEN s.source
        ELSE 'other'
    END AS utm_source,
    s.medium AS utm_medium,
    coalesce(s.campaign, '-') AS utm_campaign,
    count(l.lead_id) AS lead_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3, 4
ORDER BY 1 ASC, 5 DESC;

/* Шаг 4.11. Расчёт количества лидов по бесплатным источникам (google, organic).
Дашборд: Количество лидов из бесплатных источников. */

SELECT
    cast(to_char(l.created_at, 'YYYY-MM-DD') AS date) AS visit_date,
    s.source AS utm_source,
    s.medium AS utm_medium,
    count(l.lead_id) AS lead_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3
HAVING s.medium LIKE '%organic%'
ORDER BY 1;

/* Шаг 4.12. Расчёт количества лидов по vk и yandex. Дашборд: Количество лидов из vk и yandex (платные каналы). */

SELECT
    date_trunc('day', l.created_at) AS visit_date,
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,
    count(l.lead_id) AS lead_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3, 4
HAVING s.source IN ('vk', 'yandex')
ORDER BY 1 ASC, 5 DESC;

/* Шаг 4.13. Расчёт количества лидов по другим источникам (кроме organic, vk, yandex).
Дашборд: Количество лидов из других источников (кроме всех organic, vk и yandex). */

SELECT
    date_trunc('day', l.created_at) AS visit_date,
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,
    count(l.lead_id) AS lead_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3, 4
HAVING s.medium NOT LIKE '%organic%' AND s.source NOT IN ('vk', 'yandex')
ORDER BY 5 DESC;

/* Шаг 4.14. Рекламные кампании, не принёсшие лидов. Дашборд: Рекламные кампании, не принёсшие лидов.  */

SELECT
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,
    count(l.lead_id) AS lead_count
FROM leads AS l
RIGHT JOIN sessions AS s
    ON
        l.visitor_id = s.visitor_id
        AND l.created_at >= s.visit_date
GROUP BY 1, 2, 3
HAVING count(l.lead_id) = 0;

/* Шаг 4.15. Расчёт конверсии из клика в лид по source / medium / campaign.
Дашборд: Конверсия из клика в лид и из лида в продажу по источникам, %. */

SELECT
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,
    count(l.lead_id) AS lead_count
FROM leads AS l
RIGHT JOIN sessions AS s
    ON
        l.visitor_id = s.visitor_id
        AND l.created_at >= s.visit_date
GROUP BY 1, 2, 3
HAVING count(l.lead_id) = 0;

/* Шаг 4.16. Подготовка данных для воронки (пользователь - лид - клиент).
Дашборд: Воронка продаж по атрибуции last paid click. */

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
    GROUP BY
        date_trunc('day', visit_date),
        utm_source,
        utm_medium,
        utm_campaign
)

SELECT
    t.*,
    c.visit_date,
    c.utm_source,
    c.utm_medium,
    c.utm_campaign
FROM cte AS c
CROSS JOIN LATERAL (
    VALUES
    (c.visitors_count, '1 - Посетитель'),
    (c.leads_count, '2 - Лид'),
    (c.purchases_count, '3 - Клиент')
) AS t (turnover, funnel_metric)
ORDER BY
    c.visit_date,
    c.utm_source,
    c.utm_medium,
    c.utm_campaign,
    t.funnel_metric;

/* Шаг 4.17. Расчёт расходов на рекламу в динамике по source / medium / campaign.
Дашборды: Общие расходы на рекламу, рублей; Расходы на рекламу по кампаниям. */

SELECT
    date_trunc('day', campaign_date) AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    sum(daily_spent) AS ad_costs
FROM vk_ads
GROUP BY 1, 2, 3, 4
UNION ALL
SELECT
    date_trunc('day', campaign_date) AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    sum(daily_spent) AS ad_costs
FROM ya_ads
GROUP BY 1, 2, 3, 4
ORDER BY 1, 2, 3, 4;

/* Шаг 4.18. Создание view с рекламными расходами за весь месяц. */

CREATE VIEW last_paid_monthly_costs_nv AS
WITH costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        sum(daily_spent) AS costs
    FROM vk_ads
    GROUP BY 1, 2, 3
    UNION ALL
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        sum(daily_spent) AS costs
    FROM ya_ads
    GROUP BY 1, 2, 3
)

SELECT
    lp.visitor_id,
    lp.utm_source,
    lp.utm_medium,
    lp.utm_campaign,
    lp.lead_id,
    lp.amount,
    lp.status_id,
    c.costs
FROM last_paid_nv AS lp
LEFT JOIN costs AS c
    ON
        lp.utm_source = c.utm_source
        AND lp.utm_medium = c.utm_medium
        AND lp.utm_campaign = c.utm_campaign;

/* Шаг 4.19. Создание view с расходами за месяц и с агрегированными данными, для расчёта прибыльности вложений. */

CREATE VIEW aggregate_monthly_costs AS
SELECT
    utm_source,
    utm_medium,
    utm_campaign,
    count(DISTINCT visitor_id) AS visitors_count,
    max(costs) AS total_cost,
    count(DISTINCT lead_id) AS leads_count,
    sum(CASE
        WHEN status_id = 142 THEN 1
        ELSE 0
    END) AS purchases_count,
    sum(CASE
        WHEN status_id = 142 THEN coalesce(amount, 0)
    END) AS revenue
FROM last_paid_monthly_costs_nv
GROUP BY 1, 2, 3
ORDER BY 8 DESC NULLS LAST;

/* Шаг 4.20. Расчёт CPU по атрибуции last paid click по source / medium / campaign.
Дашборды: Расходы на пользователя (CPU) по кампаниям по атрибуции last paid click, рублей. */

SELECT
    utm_source,
    utm_medium,
    utm_campaign,
    round(sum(total_cost) * 1.0 / sum(visitors_count), 2) AS cpu
FROM aggregate_monthly_costs
GROUP BY 1, 2, 3
HAVING sum(total_cost) > 0
ORDER BY 4 DESC;

/* Шаг 4.21. Расчёт CPU по атрибуции last paid click по source. Файл cpu.csv.
Дашборд: Расходы на пользователя (CPU) по атрибуции last paid click, рублей. */
 
WITH tab AS (
    SELECT
        utm_source,
        round(sum(total_cost) * 1.0 / sum(visitors_count), 2) AS cpu
    FROM aggregate_monthly_costs
    GROUP BY 1
),

tab1 AS (
    SELECT round(sum(total_cost) * 1.0 / sum(visitors_count), 2) AS total_cpu
    FROM aggregate_monthly_costs
)

SELECT
    tab.utm_source,
    tab.cpu,
    tab1.total_cpu
FROM tab, tab1
WHERE tab.cpu > 0;

/* Шаг 4.22. Расчёт CPL по атрибуции last paid click по source / medium / campaign.
Дашборд: Расходы на лида (CPL) по рекламным кампаниям по атрибуции last paid click, рублей. */

SELECT
    utm_source,
    utm_medium,
    utm_campaign,
    round(sum(total_cost) * 1.0 / sum(leads_count), 2) AS cpl
FROM aggregate_monthly_costs
GROUP BY 1, 2, 3
HAVING sum(leads_count) > 0 AND sum(total_cost) > 0
ORDER BY 4 DESC;

/* Шаг 4.23. Расчёт CPL по атрибуции last paid click по source. Файл cpl.csv.
Дашборд: Расходы на лида (CPL) по атрибуции last paid click, рублей. */

WITH tab AS (
    SELECT
        utm_source,
        round(sum(total_cost) * 1.0 / sum(leads_count), 2) AS cpl
    FROM aggregate_monthly_costs
    GROUP BY 1
    HAVING sum(leads_count) > 0
),

tab1 AS (
    SELECT round(sum(total_cost) * 1.0 / sum(leads_count), 2) AS total_cpl
    FROM aggregate_monthly_costs
)

SELECT
    tab.utm_source,
    tab.cpl,
    tab1.total_cpl
FROM tab, tab1
WHERE tab.cpl > 0;

/* Шаг 4.24. Расчёт CPPU по атрибуции last paid click по source / medium / campaign.
Дашборд: Расходы на клиента (CPPU) по рекламным кампаниям по атрибуции last paid click, рублей.  */

SELECT
    utm_source,
    utm_medium,
    utm_campaign,
    round(sum(total_cost) * 1.0 / sum(purchases_count), 2) AS cppu
FROM aggregate_monthly_costs
GROUP BY 1, 2, 3
HAVING sum(purchases_count) > 0 AND sum(total_cost) > 0
ORDER BY 4 DESC;

/* Шаг 4.25. Расчёт CPPU по атрибуции last paid click по source / medium / campaign. Файл cppu.scv.
Дашборд: Расходы на клиента (CPPU) по атрибуции last paid click, рублей. */

WITH tab AS (
    SELECT
        utm_source,
        round(sum(total_cost) * 1.0 / sum(purchases_count), 2) AS cppu
    FROM aggregate_monthly_costs
    GROUP BY 1
    HAVING sum(purchases_count) > 0
),

tab1 AS (
    SELECT round(sum(total_cost) * 1.0 / sum(purchases_count), 2) AS total_cppu
    FROM aggregate_monthly_costs
)

SELECT
    tab.utm_source,
    tab.cppu,
    tab1.total_cppu
FROM tab, tab1
WHERE tab.cppu > 0;

/* Шаг 4.26. Расчёт ROI по атрибуции last paid click по source / medium / campaign.
Дашборд: Окупившиеся рекламные кампании и коэффициент окупаемости инвестиций (ROI) по атрибуции last paid click, %. */

SELECT
    utm_source,
    utm_medium,
    utm_campaign,
    round(
        (coalesce(sum(revenue), 0) - sum(total_cost)) * 100.0 / sum(total_cost),
        2
    ) AS roi
FROM aggregate_monthly_costs
GROUP BY 1, 2, 3
HAVING sum(total_cost) > 0
ORDER BY 4 DESC;

/* Шаг 4.27. Расчёт коэффициента окупаемости инвестиций (ROI) по атрибуции last paid click. Файл roi.csv.
Дашборд: Коэффициент окупаемости инвестиций (ROI) по атрибуции last paid click, %. */

WITH tab AS (
    SELECT
        utm_source,
        round(
            (coalesce(sum(revenue), 0) - sum(total_cost))
            * 100.0
            / sum(total_cost),
            2
        ) AS roi
    FROM aggregate_monthly_costs
    GROUP BY 1
    HAVING sum(total_cost) > 0
),

tab1 AS (
    SELECT
        round(
            (coalesce(sum(revenue), 0) - sum(total_cost))
            * 100.0
            / sum(total_cost),
            2
        ) AS total_roi
    FROM aggregate_monthly_costs
)

SELECT
    tab.utm_source,
    tab.roi,
    tab1.total_roi
FROM tab, tab1;

/* Шаг 4.28. Поиск даты начала рекламных кампаний с низким ROI.
Дашборд: Рекламные кампании с низким коэффициентом окупаемости инвестиций (ROI) по дате начала кампании по атрибуции last paid click, %. */

WITH tab AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        round(
            (coalesce(sum(revenue), 0) - sum(total_cost))
            * 100.0
            / sum(total_cost),
            2
        ) AS roi
    FROM aggregate_monthly_costs
    GROUP BY 1, 2, 3
    HAVING sum(total_cost) > 0 AND (
        round(
            (coalesce(sum(revenue), 0) - sum(total_cost))
            * 100.0
            / sum(total_cost),
            2) > 0 AND round(
            (coalesce(sum(revenue), 0) - sum(total_cost))
            * 100.0
            / sum(total_cost),
            2
        ) < 200
    )
),

tab1 AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        leads_count,
        purchases_count AS client_count,
        total_cost,
        coalesce(revenue, 0) AS revenue,
        coalesce(revenue, 0) - total_cost AS net_revenue
    FROM aggregate_monthly_costs
    WHERE
        (coalesce(revenue, 0) - total_cost != 0)
        OR (coalesce(revenue, 0) - total_cost = 0 AND total_cost > 0)
),

tab2 AS (
    SELECT
        *,
        first_value(visit_date)
            OVER (
                PARTITION BY utm_source, utm_medium, utm_campaign
                ORDER BY visit_date
            )
        AS campaign_beginning
    FROM last_paid_costs_nv
),

tab3 AS (
    SELECT DISTINCT ON (tab1.utm_source, tab1.utm_medium, tab1.utm_campaign)
        tab2.campaign_beginning,
        tab1.utm_source,
        tab1.utm_medium,
        tab1.utm_campaign,
        tab1.leads_count,
        tab1.client_count,
        tab1.revenue,
        tab1.total_cost,
        tab1.net_revenue
    FROM tab1
    INNER JOIN tab2
        ON
            tab1.utm_source = tab2.utm_source
            AND tab1.utm_medium = tab2.utm_medium
            AND tab1.utm_campaign = tab2.utm_campaign
)

SELECT tab3.*
FROM tab
INNER JOIN tab3
    ON
        tab.utm_source = tab3.utm_source
        AND tab.utm_medium = tab3.utm_medium
        AND tab.utm_campaign = tab3.utm_campaign


/* Шаг 4.29. Поиск убыточных рекламных кампаний по атрибуции last paid click.
Дашборд: Убыточные рекламные кампании по атрибуции last paid click, рублей. */

WITH tab1 AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        leads_count,
        purchases_count AS client_count,
        coalesce(revenue, 0) AS revenue,
        total_cost,
        coalesce(revenue, 0) - total_cost AS net_revenue
    FROM aggregate_monthly_costs
    WHERE
        (coalesce(revenue, 0) - total_cost != 0)
        OR (coalesce(revenue, 0) - total_cost = 0 AND total_cost > 0)
    ORDER BY 8
),

tab2 AS (
    SELECT
        *,
        first_value(visit_date)
            OVER (
                PARTITION BY utm_source, utm_medium, utm_campaign
                ORDER BY visit_date
            )
        AS campaign_beginning
    FROM last_paid_costs_nv
)

SELECT DISTINCT ON (tab1.utm_source, tab1.utm_medium, tab1.utm_campaign)
    tab2.campaign_beginning,
    tab1.utm_source,
    tab1.utm_medium,
    tab1.utm_campaign,
    tab1.leads_count,
    tab1.client_count,
    tab1.revenue,
    tab1.total_cost,
    tab1.net_revenue
FROM tab1
INNER JOIN tab2
    ON
        tab1.utm_source = tab2.utm_source
        AND tab1.utm_medium = tab2.utm_medium
        AND tab1.utm_campaign = tab2.utm_campaign;
