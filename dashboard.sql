/* Дашборд Количество пользователей из всех источников. Шаг 4.7. Расчёт количества посетителей сайта по source / medium / campaign по дням. Файл daily_visitors_count_from_campaign.csv */

SELECT
    date_trunc('day', visit_date) AS visit_date,
    medium,
    campaign,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
ORDER BY 4 ASC, 5 DESC;

/* Дашборд Количество пользователей по источникам. Шаг 4. Расчёт количества посетителей по источникам (объединённые) за месяц. для выявления наибольших источников*/

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

/* Дашборд Количество пользователей по источникам Шаг 4. Расчёт количества посетителей по источникам, принёсших наибольшее количество посетителей */

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

/* Дашборд Количество пользователей по прямым переходам из google и organic. Шаг 4. Расчёт количества посетителей сайта по бесплатным источникам (google, organic) */

with tab as (
SELECT
    date_trunc('day', visit_date) AS visit_date,
    source as utm_source,
    medium as utm_medium,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3
having medium like '%organic%'
ORDER BY 4 desc
)
select
    visit_date,
    utm_source,
    sum(visitors_count) as visitors_count
from tab
group by 1, 2
having utm_source in ('google', 'organic')
order by 1 asc, 3 desc

/* Дашборд Шаг Количество пользователей из других бесплатных источников (кроме google и organic). 4. Расчёт количества посетителей сайта по другим бесплатным источникам (кроме google, organic) */

with tab as (
SELECT
    date_trunc('day', visit_date) AS visit_date,
    source as utm_source,
    medium as utm_medium,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3
having medium like '%organic%'
ORDER BY 4 desc
)
select
    visit_date,
    utm_source,
    sum(visitors_count) as visitors_count
from tab
group by 1, 2
having utm_source Not in ('google', 'organic')
order by 1 asc, 3 desc;

/* Дашборд Количество пользователей из vk и yandex (платные каналы), Количество пользователей из vk по типу рекламной компании,
Количество пользователей из yandex (cpc) по рекламным кампаниям
Шаг 4. Расчёт количества посетителей сайта по vk и yandex */

SELECT
    date_trunc('day', visit_date) AS visit_date,
    source as utm_source,
    medium as utm_medium,
    campaign as utm_campaign,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
having /*medium like '%organic%' or */ "source" in ('vk', 'yandex')
ORDER BY 5 desc;

/* Дашборд Количество пользователей по другим источникам (кроме всех organic, vk и yandex),
Количество пользователей из других источников (кроме всех organic, vk и yandex)
Шаг 4. Расчёт количества посетителей сайта по другим источникам (кроме organic, vk, yandex) */

SELECT
    date_trunc('day', visit_date) AS visit_date,
    source as utm_source,
    medium as utm_medium,
    campaign as utm_campaign,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
having medium not like '%organic%' and "source" not in ('vk', 'yandex')
ORDER BY 5 desc;

/* Дашборд Коэффициент липучести. Шаг 4.12 Расчёт коэффициента липучести. Файл sticky_factor.csv */

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

/* Дашборд Количество лидов из всех источников. Шаг 4.19. Расчёт количества лидов по source / medium / campaign по дням. Файл daily_leads_count_from_campaign.csv */

SELECT
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,
    date_trunc('day', l.created_at) AS visit_date,
    count(l.lead_id) AS lead_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC;


/* Дашборд Количество лидов по источникам Шаг 4. Расчёт количества лидов по источникам, принёсших наибольшее количество пользователей */

SELECT
    date_trunc('day', l.created_at) AS visit_date,
    CASE
        WHEN s.source IN ('google', 'organic', 'yandex', 'vk') THEN s.source
        ELSE 'other'
    END AS utm_source,
    s.medium AS utm_medium,
    coalesce(s.campaign, '-') AS utm_campaign,
    count(l.lead_id) AS lead_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3, 4
ORDER BY 1 asc, 5  DESC;

/* Дашборд Количество лидов по прямым переходам из google и organic. 
 * Шаг 4. Расчёт количества лидов сайта по бесплатным источникам (google, organic) */

SELECT
    To_char(l.created_at, 'DD-MM-YYYY') :: date AS visit_date,
    source as utm_source,
    medium as utm_medium,
    count(l.lead_id) AS lead_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3
having medium like '%organic%'
order by 1


/* Дашборд Количество лидов из vk и yandex (платные каналы), Количество лидов из vk по рекламным кампаниям,
Количество лидов из yandex по рекламным кампаниям
Шаг 4. Расчёт количества лидов по vk и yandex */

SELECT
    date_trunc('day', l.created_at) AS visit_date,
    source as utm_source,
    medium as utm_medium,
    campaign as utm_campaign,
    count(l.lead_id) AS lead_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3, 4
having s.source in ('vk', 'yandex')
ORDER BY 1 asc, 5 desc;

/* Дашборд Количество лидов из других источников (кроме всех organic, vk и yandex)
Шаг 4. Расчёт количества лидов по другим источникам (кроме organic, vk, yandex) */

SELECT
    date_trunc('day', l.created_at) AS visit_date,
    source as utm_source,
    medium as utm_medium,
    campaign as utm_campaign,
    count(l.lead_id) AS lead_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2, 3, 4
having medium not like '%organic%' and "source" not in ('vk', 'yandex')
ORDER BY 5 desc;

/* Дашборд Рекламные кампании, не принёсшие лидов. Шаг 4. Рекламные кампании, не принёсшие лидов */

WITH vk_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        sum(daily_spent) AS vk_costs
    FROM vk_ads
    GROUP BY 1, 2, 3
),
ya_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        sum(daily_spent) AS ya_costs
    FROM ya_ads
    GROUP BY 1, 2, 3
),
tab1 as (
select
    source as utm_source,
    medium as utm_medium,
    campaign as utm_campaign,
    count(l.lead_id) AS lead_count,
    sum(coalesce(l.amount, 0)) as revenue
FROM leads AS l
RIGHT JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
    and s.visit_date <= l.created_at
GROUP BY 1, 2, 3
)/*,
tab2 as (*/
select
    tab1.utm_source,
    tab1.utm_medium,
    tab1.utm_campaign,
    sum(tab1.lead_count) as lead_count,
    max(CASE
        WHEN vk_costs IS NOT NULL THEN vk_costs
        WHEN ya_costs IS NOT NULL THEN ya_costs
        ELSE 0
    END) AS total_cost,
    sum(tab1.revenue) as revenue,
    sum(tab1.revenue) - max(CASE
        WHEN vk_costs IS NOT NULL THEN vk_costs
        WHEN ya_costs IS NOT NULL THEN ya_costs
        ELSE 0 end) as net_revenue
FROM tab1
LEFT JOIN vk_costs AS vk
    ON
        tab1.utm_source = vk.utm_source
        AND tab1.utm_medium = vk.utm_medium
        AND tab1.utm_campaign = vk.utm_campaign
LEFT JOIN ya_costs AS ya
    ON
        tab1.utm_source = ya.utm_source
        AND tab1.utm_medium = ya.utm_medium
        AND tab1.utm_campaign = ya.utm_campaign
group by 1, 2, 3
having sum(tab1.lead_count) = 0 or (sum(tab1.lead_count) >= 0 and sum(tab1.revenue) - max(CASE
        WHEN vk_costs IS NOT NULL THEN vk_costs
        WHEN ya_costs IS NOT NULL THEN ya_costs
        ELSE 0 end) < 0)
order by 7, 1, 2, 3

/* Дашборд Конверсия из клика в лид и из лида в продажу по источникам. Шаг 4.26. Расчёт конверсии из клика в лид по source / medium / campaign. Файл lcr_from_campaign.csv */

WITH lcr as (
SELECT
    s.source as utm_source,
    s.medium  as utm_medium,
    s.campaign as utm_campaign,
    count(DISTINCT s.visitor_id) as visitors_count,
    case when count(DISTINCT l.lead_id) > 0 then count(DISTINCT l.lead_id) else -1 end AS lead_count,
    sum(CASE WHEN l.status_id = 142 THEN 1 ELSE 0 END) as client_count
FROM sessions AS s
LEFT JOIN leads AS l
    ON
        s.visitor_id = l.visitor_id
        AND s.visit_date <= l.created_at
GROUP BY 1, 2, 3
)
SELECT
    utm_source,
    utm_medium,
    utm_campaign,
    round(lead_count * 100.0 / visitors_count, 2) AS user_to_lead_rate,
    round(client_count * 100.0 / lead_count, 2) AS lead_to_client_rate
FROM lcr
where lead_count > 0

/* Дашборд Воронка продаж по атрибуции last paid click. Шаг 4. Подготовка данных для воронки (пользователь - лид - клиент)*/

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

/* Дашборд Рекламные кампании, не принёсшие клиентов. Дашборд Убыточные рекламные компании, рублей */

WITH vk_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        sum(daily_spent) AS vk_costs
    FROM vk_ads
    GROUP BY 1, 2, 3
),
ya_costs AS (
    SELECT
        utm_source,
        utm_medium,
        utm_campaign,
        sum(daily_spent) AS ya_costs
    FROM ya_ads
    GROUP BY 1, 2, 3
),
tab1 as (
select
    source as utm_source,
    medium as utm_medium,
    campaign as utm_campaign,
    count(l.lead_id) AS lead_count,
    sum(CASE
            WHEN status_id = 142 THEN 1
            ELSE 0
        END) AS client_count,
    sum(coalesce(l.amount, 0)) as revenue
FROM leads AS l
RIGHT JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
    and s.visit_date <= l.created_at
GROUP BY 1, 2, 3
)/*,
tab2 as (*/
select
    tab1.utm_source,
    tab1.utm_medium,
    tab1.utm_campaign,
    sum(tab1.lead_count) as lead_count,
    sum(tab1.client_count) as client_count,
    max(CASE
        WHEN vk_costs IS NOT NULL THEN vk_costs
        WHEN ya_costs IS NOT NULL THEN ya_costs
        ELSE 0
    END) AS total_cost,
    sum(tab1.revenue) as revenue,
    sum(tab1.revenue) - max(CASE
        WHEN vk_costs IS NOT NULL THEN vk_costs
        WHEN ya_costs IS NOT NULL THEN ya_costs
        ELSE 0 end) as net_revenue
FROM tab1
LEFT JOIN vk_costs AS vk
    ON
        tab1.utm_source = vk.utm_source
        AND tab1.utm_medium = vk.utm_medium
        AND tab1.utm_campaign = vk.utm_campaign
LEFT JOIN ya_costs AS ya
    ON
        tab1.utm_source = ya.utm_source
        AND tab1.utm_medium = ya.utm_medium
        AND tab1.utm_campaign = ya.utm_campaign
group by 1, 2, 3
having sum(tab1.client_count) = 0 or (sum(tab1.client_count) >= 0 and sum(tab1.revenue) - max(CASE
        WHEN vk_costs IS NOT NULL THEN vk_costs
        WHEN ya_costs IS NOT NULL THEN ya_costs
        ELSE 0 end) < 0)
order by 8, 1, 2, 3;



/* Дашборд Общие расходы на рекламу , Расходы на рекламу по кампаниям
Шаг 4.31. Расчёт расходов на рекламу в динамике по source / medium / campaign. Файл ad_costs_campaign.csv */

SELECT
    date_trunc('day', campaign_date) AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    sum(daily_spent) AS ad_costs
FROM vk_ads
GROUP BY 1, 2, 3, 4
UNION all
SELECT
    date_trunc('day', campaign_date) AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    sum(daily_spent) AS ad_costs
FROM ya_ads
GROUP BY 1, 2, 3, 4
ORDER BY 1, 2, 3, 4;

/* Дашборд Расходы на пользователя (CPU) по атрибуции last paid click, рублей. Расходы на пользователя (CPU) по атрибуции last paid click по источникам, рублей
 Шаг 4.37. Расчёт CPU по дням по атрибуции last paid click по source / medium / campaign. Файл daily_cpu_campaign.scv */

SELECT
    to_char(visit_date, 'YYYY-MM-DD') :: date AS visit_date,
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

/* Дашборд Расходы на лида (CPL) по атрибуции last paid click, рублей. Расходы на лида (CPL) по атрибуции last paid click по источникам, рублей
 Шаг 4.43. Расчёт CPL по дням по атрибуции last paid click по source / medium / campaign. Файл daily_cpl_campaign.scv */

SELECT
    to_char(visit_date, 'YYYY-MM-DD') :: date AS visit_date,
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

/* Дашборд Расходы на клиента (CPPU) по атрибуции last paid click, рублей Шаг 4.49. Расчёт CPPU по дням по атрибуции last paid click по source / medium / campaign. Файл daily_cppu_campaign.scv */

SELECT
    to_char(visit_date, 'YYYY-MM-DD') :: date AS visit_date,
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

/* Дашборд Окупившиеся рекламные кампании и коэффициент окупаемости инвестиций (ROI) по атрибуции last paid click, % 
Шаг 4.55. Расчёт ROI по дням по атрибуции last paid click по source / medium / campaign. Файл daily_roi_campaign.scv */

SELECT
    to_char(visit_date, 'YYYY-MM-DD') :: date AS visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    round((sum(amount) - max(CASE
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
    and     round((sum(amount) - max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END)) * 100.0 / max(CASE
        WHEN vk_daily_spent IS NOT null THEN vk_daily_spent
        WHEN ya_daily_spent IS NOT null THEN ya_daily_spent
        ELSE 0
    END), 2) is not null
ORDER BY 5 DESC NULLS LAST;
