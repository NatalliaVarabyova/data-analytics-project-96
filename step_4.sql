/* Шаг 4.1. Рассчёт количества посетителей сайта по дням. Файл daily_visitors_count.csv */

SELECT
    to_char(visit_date, 'YYYY-MM-DD') AS visit_date,
    count(distinct visitor_id) as daily_visitor_count
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
    count(distinct visitor_id) as weekly_visitors_count
FROM sessions
GROUP BY 1;

/* Шаг 4.3. Рассчёт количества посетителей сайта по источникам за июнь. Файл source_visitors_count.csv */

SELECT
    source,
    count(distinct visitor_id) AS visitors_count
FROM sessions
GROUP BY 1
ORDER BY 2 DESC;

/* Шаг 4.4. Рассчёт количества посетителей сайта по источникам по дням. Файл daily_visitors_count_from_source.csv */

SELECT
    source,
    to_char(visit_date, 'YYYY-MM-DD') AS visit_date,
    count(distinct visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2
ORDER BY 2 asc, 3 desc;

/* Шаг 4.5. Рассчёт количества посетителей сайта по источникам в неделю. Файл weekly_visitors_count_from_source.csv */

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
    count(distinct visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2
ORDER BY 2 asc, 3 desc;

/* Шаг 4.6. Рассчёт количества посетителей сайта по source / medium / campaign за июнь. Файл  */

SELECT
    source,
    medium,
    campaign,
    count(distinct visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3
ORDER BY 4 DESC;

/* Шаг 4.7. Рассчёт количества посетителей сайта по source / medium / campaign по дням. Файл  */

SELECT
    source,
    medium,
    campaign,
    to_char(visit_date, 'YYYY-MM-DD') AS visit_date,
    count(distinct visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
ORDER BY 4 asc, 5 desc;

/* Шаг 4.8. Рассчёт количества посетителей сайта по source / medium / campaign в неделю. Файл  */

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
    count(distinct visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2, 3, 4
ORDER BY 4 asc, 5 desc;

/* Шаг 4.9. Рассчёт количества посетителей сайта по source / medium за июнь. Файл  */

SELECT
 --   source,
    case 
    	when lower(medium) = 'organic' then lower(medium)
    	else 'paid'
    end as medium,
    count(distinct visitor_id) AS visitors_count
FROM sessions
GROUP BY 1
ORDER BY 2 DESC;

/* Шаг 4.7. Рассчёт количества посетителей сайта по source / medium по дням. Файл  */

SELECT
 --   source,
    case 
    	when lower(medium) = 'organic' then lower(medium)
    	else 'paid'
    end as medium,
    to_char(visit_date, 'YYYY-MM-DD') AS visit_date,
    count(distinct visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2
ORDER BY 2 asc, 3 desc;

/* Шаг 4.8. Рассчёт количества посетителей сайта по source / medium в неделю. Файл  */

SELECT
    --source,
    case 
    	when lower(medium) = 'organic' then lower(medium)
    	else 'paid'
    end as medium,
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
    count(distinct visitor_id) AS visitors_count
FROM sessions
GROUP BY 1, 2
ORDER BY 2 asc, 3 desc;