-- Otázka 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
WITH rocni_shrnuti AS (
    SELECT 
        rok_spolecny,
        AVG(prumerna_mzda) AS prumerna_mzda_v_roce,
        AVG(prumerna_cena_potraviny) AS prumerna_cena_v_roce
    FROM t_dominik_voros_project_sql_primary_final AS tdvpspf 
    GROUP BY rok_spolecny
),
mezirocni_narusty AS (
    SELECT 
        rok_spolecny,
        ((prumerna_mzda_v_roce / LAG(prumerna_mzda_v_roce) OVER (ORDER BY rok_spolecny)) - 1) * 100 AS narust_mezd_pct,-- počítáme nominální nárust mezd v procentech
        ((prumerna_cena_v_roce / LAG(prumerna_cena_v_roce) OVER (ORDER BY rok_spolecny)) - 1) * 100 AS narust_cen_pct -- počítáme nominální nárůst cen potravin v procentech
    FROM rocni_shrnuti
)
	SELECT 
    rok_spolecny,
    ROUND(CAST(narust_cen_pct AS numeric), 2) AS narust_cen_pct,
    ROUND(CAST(narust_mezd_pct AS numeric), 2) AS narust_mezd_pct,
    ROUND(CAST(narust_cen_pct - narust_mezd_pct AS numeric), 2) AS rozdíl_v_procentech
FROM mezirocni_narusty
WHERE narust_cen_pct IS NOT NULL
ORDER BY rozdíl_v_procentech DESC;

-- Závěr: Ne, ve sledovaném období neexistuje rok, ve kterém by byl meziroční nárůst cen potravin o více než 10 % vyšší než růst mezd.
---------------------------------------------------------------------------------------------------------------	

