CREATE TABLE last_paid_click AS
SELECT DISTINCT
    s.visitor_id,
    s.visit_date,
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,
    l.lead_id,
    l.created_at,
    l.amount,
    l.closing_reason,
    l.status_id
FROM sessions AS s
LEFT JOIN leads AS l
    ON s.visitor_id = l.visitor_id
WHERE s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg')
ORDER BY
    s.visit_date,
    s.source, s.medium,
    s.campaign;
    