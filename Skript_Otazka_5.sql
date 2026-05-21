-- Otázka 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
WITH rocni_agregace AS (
    SELECT 
        rok_spolecny,
        AVG(prumerna_mzda) AS prumerna_mzda,
        AVG(prumerna_cena_potraviny) AS prumerna_cena_potraviny,
        AVG(hdp_v_roce) AS hdp
    FROM t_dominik_voros_project_sql_primary_final
    GROUP BY rok_spolecny
),
mezirocni_rust AS (
    SELECT 
        rok_spolecny,
        ROUND(((hdp - LAG(hdp) OVER (ORDER BY rok_spolecny)) / LAG(hdp) OVER (ORDER BY rok_spolecny) * 100)::numeric, 2) AS rust_gdp_pct,
        ROUND(((prumerna_mzda - LAG(prumerna_mzda) OVER (ORDER BY rok_spolecny)) / LAG(prumerna_mzda) OVER (ORDER BY rok_spolecny) * 100)::numeric, 2) AS rust_mezd_pct,
        ROUND(((prumerna_cena_potraviny - LAG(prumerna_cena_potraviny) OVER (ORDER BY rok_spolecny)) / LAG(prumerna_cena_potraviny) OVER (ORDER BY rok_spolecny) * 100)::numeric, 2) AS rust_cen_pct
    FROM rocni_agregace
)
SELECT 
    rok_spolecny AS rok,
    rust_gdp_pct AS zmena_hdp_procenta,
    rust_mezd_pct AS zmena_mezd_procenta,
    rust_cen_pct AS zmena_cen_potravin_procenta,
    -- Pohled na vývoj mezd a cen v následujícím roce
    LEAD(rust_mezd_pct) OVER (ORDER BY rok_spolecny) AS zmena_mezd_dalsi_rok,
    LEAD(rust_cen_pct) OVER (ORDER BY rok_spolecny) AS zmena_cen_potravin_dalsi_rok
FROM mezirocni_rust
WHERE rust_gdp_pct IS NOT NULL
ORDER BY rok;