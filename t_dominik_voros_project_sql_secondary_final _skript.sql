CREATE TABLE t_dominik_voros_project_sql_secondary_final AS
SELECT 
    e.country,
    e.year,
    ROUND(e.gdp::numeric, 2) AS hdp_zakrouhleno,
    e.gini,
    round(e.taxes::NUMERIC,2) AS daně_zakrouhleno,
    c.continent
FROM economies e
JOIN countries c ON e.country = c.country
WHERE c.continent = 'Europe' 
  AND e.year BETWEEN 2006 AND 2018
  AND e.country != 'Czech Republic'
  AND e.gdp IS NOT NULL 
ORDER BY e.country, e.year;

-- Kontrola výsledku
SELECT * FROM t_dominik_voros_project_sql_secondary_final;



