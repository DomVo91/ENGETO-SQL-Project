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

-- Období silného růstu (2007, 2015, 2017)
-- pozn. I když HDP roste pokaždé stejně silně, ceny potravin jednou klesnou, podruhé reagují se zpožděním a potřetí okamžitě. Přímá závislost tu neplatí.

--Období stagnace a krizí (2009, 2012, 2013)
-- komentář: V krizi roku 2009 potraviny zlevnily, ale v recesi roku 2012 lidem klesaly mzdy a potraviny přesto výrazně zdražovaly. To opět potvrzuje, že ceny potravin si často žijí vlastním životem nezávisle na HDP.

-- Na základě analýzy nelze jednoznačně tvrdit, že by výše HDP měla přímý a předvídatelný vliv na změny cen potravin a mezd. 
-- Ekonomické ukazatele se chovají v každém období jinak a vykazují značnou volatilitu.

