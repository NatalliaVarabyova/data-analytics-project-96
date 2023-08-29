/* Step3. */

CREATE VIEW last_paid_click_with_costs_vorobyova AS
WITH tab AS (
    SELECT DISTINCT ON (s.visitor_id)
        s.visitor_id,
        to_char(s.visit_date, 'YYYY-MM-DD') AS visit_date,
        s.landing_page,
        s.source AS utm_source,
        s.medium AS utm_medium,
        s.campaign AS utm_campaign,
        s.content AS utm_content,
        l.lead_id,
        coalesce(l.amount, 0) AS amount,
        l.created_at,
        l.closing_reason,
        l.status_id,
        vk.ad_id AS vk_ad_id,
        vk.campaign_name AS vk_campaign_name,
        vk.campaign_date AS vk_campaign_date,
        coalesce(vk.daily_spent, 0) AS vk_daily_spent,
        ya.ad_id AS ya_ad_id,
        ya.campaign_name AS ya_campaign_name,
        ya.campaign_date AS ya_campaign_date,
        coalesce(ya.daily_spent, 0) AS ya_daily_spent
    FROM sessions AS s
    LEFT JOIN vk_ads AS vk
        ON
            s.source = vk.utm_source
            AND s.medium = vk.utm_medium
            AND s.campaign = vk.utm_campaign
            AND s.content = vk.utm_content
    LEFT JOIN ya_ads AS ya
        ON
            s.source = ya.utm_source
            AND s.medium = ya.utm_medium
            AND s.campaign = ya.utm_campaign
            AND s.content = ya.utm_content
    LEFT JOIN leads AS l
        ON s.visitor_id = l.visitor_id
    WHERE s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg')
    ORDER BY s.visitor_id ASC, s.visit_date DESC
)

SELECT * FROM tab
ORDER BY visit_date, utm_source, utm_medium, utm_campaign;

SELECT
    visit_date,
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
    sum(coalesce(amount, 0)) AS revenue
FROM last_paid_click_with_costs_vorobyova
GROUP BY 1, 2, 3, 4
ORDER BY 1 ASC, 5 DESC, 2 ASC, 3 ASC, 4 ASC;
