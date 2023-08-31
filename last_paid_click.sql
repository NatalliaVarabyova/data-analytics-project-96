/* Step 2.1. View creation */

CREATE VIEW last_paid_nv AS
WITH tab1 AS (
    SELECT
        s.visitor_id,
        s.visit_date,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        s.content AS utm_content,
        l.lead_id,
        l.created_at,
        l.amount,
        l.closing_reason,
        l.status_id
    FROM sessions AS s
    LEFT JOIN leads AS l
        ON s.visitor_id = l.visitor_id
),

tab2 AS (
    SELECT DISTINCT ON (a.visitor_id)
        a.visitor_id,
        coalesce(b.visit_date, a.visit_date) AS visit_date,
        coalesce(b.utm_source, a.utm_source) AS utm_source,
        coalesce(b.utm_medium, 'organic') AS utm_medium,
        b.utm_campaign,
        b.utm_content,
        b.lead_id,
        b.created_at,
        b.amount,
        b.closing_reason,
        b.status_id
    FROM tab1 AS a
    LEFT JOIN tab1 AS b
        ON a.visitor_id = b.visitor_id AND b.utm_medium != 'organic'
    ORDER BY a.visitor_id ASC, b.visit_date DESC, a.visit_date DESC
)

SELECT *
FROM tab2
ORDER BY date_trunc('day', visit_date), utm_source, utm_medium, utm_campaign;

/*Step 2.2. Selection top-10 paid sales */

SELECT
    visitor_id,
    visit_date,
    utm_source,
    utm_medium,
    utm_campaign,
    lead_id,
    created_at,
    amount,
    closing_reason,
    status_id
FROM last_paid_nv
ORDER BY amount DESC NULLS LAST
LIMIT 10;

