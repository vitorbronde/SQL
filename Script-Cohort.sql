WITH entry_month AS (
  SELECT profile_id,
    BR_TIME(MIN(lead_created_at)) AS entry_date,
    DATE_PART('year', BR_TIME(MIN(lead_created_at))) || '/' || DATE_PART('month', BR_TIME(MIN(lead_created_at))) AS cohort
  FROM getninjas_dispatch.enriched_leads
  WHERE NOT lead_giveaway
  AND price_in_credits > 0
  AND country_code = 'BR'
  GROUP BY 1
)

 SELECT eq.cohort,
   DATEDIFF('month', eq.entry_date, BR_TIME(el.lead_created_at)) AS diff_months,
   COUNT(DISTINCT el.profile_id) AS n_pros,
   round(SUM(el.revenue_in_brl),2) AS revenue
FROM getninjas_dispatch.enriched_leads AS el
  LEFT JOIN entry_month AS eq ON el.profile_id = eq.profile_id
WHERE DATE_TRUNC('month', BR_TIME(lead_created_at)) <> DATE_TRUNC('month', BR_TIME(CURRENT_TIMESTAMP::TIMESTAMP))
  AND NOT lead_giveaway
  AND price_in_credits > 0
  AND country_code = 'BR'
GROUP BY 1,2,MONTH(BR_TIME(lead_created_at))
ORDER BY 1,2