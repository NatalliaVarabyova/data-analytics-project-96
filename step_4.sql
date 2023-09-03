/* Шаг 4.1. Рассчёт количества посетителей сайта по дням. */

SELECT
    to_char(visit_date, 'YYYY-MM-DD') AS visit_date,
    count(visitor_id)
FROM last_paid_costs_nv
GROUP BY 1
ORDER BY 1;

/* Шаг 4.2. Рассчёт количества посетителей сайта по источникам. */

SELECT
    utm_source,
    count(visitor_id) AS visitors_count
FROM last_paid_costs_nv
GROUP BY 1
ORDER BY 2 DESC;