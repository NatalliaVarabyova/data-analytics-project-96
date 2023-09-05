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

/* Шаг 4.6. Расчёт количества посетителей сайта по source / medium / campaign за июнь. Файл daily_visitors_count_from_campaign */

SELECT
    source,
    medium,
    campaign,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3
ORDER BY 4 DESC;

/* Шаг 4.7. Расчёт количества посетителей сайта по source / medium / campaign по дням. Файл daily_visitors_count_from_campaign */

SELECT
    source,
    medium,
    campaign,
    to_char(visit_date, 'YYYY-MM-DD') AS visit_date,
    count(DISTINCT visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
ORDER BY 4 ASC, 5 DESC;

/* Шаг 4.8. Расчёт количества посетителей сайта по source / medium / campaign в неделю. Файл weekly_visitors_count_from_campaign */

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

/* Шаг 4.9. Расчёт количества посетителей сайта по source / medium за июнь. Файл monthly_visitors_count_from_medium */

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

/* Шаг 4.10. Расчёт количества посетителей сайта по source / medium по дням. Файл daily_visitors_count_from_medium */

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

/* Шаг 4.11. Расчёт количества посетителей сайта по source / medium в неделю. Файл weekly_visitors_count_from_medium */

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

/* Шаг 4.12. Расчёт количества лидов по дням. Файл daily_leads_count.csv */

SELECT
    to_char(created_at, 'YYYY-MM-DD') AS created_at,
    count(lead_id) AS leads_count
FROM leads
GROUP BY 1
ORDER BY 1;

/* Шаг 4.13 Расчёт количества лидов в неделю. Файл weekly_leads_count.csv*/

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

/* Шаг 4.14. Расчёт количества лидов по источникам за июнь. Файл monthly_leads_count_from_source.csv */

SELECT
    s.source,
    count(l.lead_id) AS leads_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1
ORDER BY 2 DESC;

/* Шаг 4.15. Расчёт количества лидов по источникам по дням. Файл daily_leads_count_from_source.csv */

SELECT
    s.source,
    to_char(l.created_at, 'YYYY-MM-DD') AS created_at,
    count(l.lead_id) AS leads_count
FROM leads AS l
INNER JOIN sessions AS s
    ON l.visitor_id = s.visitor_id
GROUP BY 1, 2
ORDER BY 2 ASC, 3 DESC;

/* Шаг 4.16. Расчёт количества лидов по источникам в неделю. Файл weekly_leads_count_from_source.csv */

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

/* Шаг 4.17. Расчёт количества лидов по source / medium / campaign за июнь. Файл monthly_leads_count_from_campaign.csv */

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

/* Шаг 4.18. Расчёт количества лидов по source / medium / campaign по дням. Файл daily_leads_count_from_campaign.csv */

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

/* Шаг 4.19. Расчёт количества лидов по source / medium / campaign в неделю. Файл weekly_leads_count_from_campaign.csv */

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

/* Шаг 4.20. Расчёт количества лидов по source / medium за июнь. Файл monthly_leads_count_from_medium.csv */

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

/* Шаг 4.21. Расчёт количества лидов по source / medium по дням. Файл daily_leads_count_from_medium.csv */

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

/* Шаг 4.22. Расчёт количества лидов по source / medium в неделю. Файл weekly_leads_count_from_medium.csv */

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

