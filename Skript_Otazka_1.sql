-- Otázka 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
WITH mzdy_v_case AS (
    -- Nejdříve data seskupíme, abychom měli pro každé odvětví a rok jeden průměr
    SELECT 
        rok_spolecny,
        nazev_odvetvi,
        AVG(prumerna_mzda) AS mzda_v_roce
    FROM t_dominik_voros_project_sql_primary_final AS tdvpspf 
    GROUP BY rok_spolecny, nazev_odvetvi
)
SELECT 
    rok_spolecny,
    nazev_odvetvi,
    mzda_v_roce,
    -- LAG se podívá na předchozí rok, ale jen v rámci daného odvětví (PARTITION BY)
    LAG(mzda_v_roce) OVER (PARTITION BY nazev_odvetvi ORDER BY rok_spolecny) AS mzda_minuly_rok,
    -- Výpočet absolutního rozdílu
    mzda_v_roce - LAG(mzda_v_roce) OVER (PARTITION BY nazev_odvetvi ORDER BY rok_spolecny) AS rozdil_v_czk
FROM mzdy_v_case
ORDER BY rozdil_v_czk;

--Závěr: Mzdy v průběhu let nominálně rostou ve všech odvětvích. 
--  Dlouhodobě rostou všude, ale krátkodobě (meziročně) vlivem hospodářských cyklů v konkrétních odvětvích mzdy klesají, což se nejvýrazněji projevilo kolem roku 2013 a to konkrétně v těžbě a dobývání, výroby a rozvodu elektřiny a peněžnictví a pojišťovnictví.
---------------------------------------------------------------------------------------------------------------	