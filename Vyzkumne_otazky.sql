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

-- Otázka 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
SELECT 
	rok_spolecny, 
	nazev_potraviny,
	round(AVG(prumerna_mzda)/AVG(prumerna_cena_potraviny)) AS kupni_cena
FROM t_dominik_voros_project_sql_primary_final AS tdvpspf
WHERE rok_spolecny IN (2006, 2018)
AND (nazev_potraviny ILIKE 'Chléb%' OR  nazev_potraviny ILIKE 'Mléko%')
GROUP BY nazev_potraviny, rok_spolecny;

-- Bylo porovnáváno první a poslední sledované období, tedy rok 2006 a 2018.
-- Interpretace: Mléko: nárůst o cca 14 % (ze 1460 na 1667 l). Chléb: nárůst o cca 4 % (ze 1308 na 1363 kg).
---------------------------------------------------------------------------------------------------------------	

-- Otázka 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
WITH mezirocni_zmeny AS (
    SELECT 
        nazev_potraviny,
        prumerna_cena_potraviny,
        -- Získání ceny z předchozího roku
        LAG(prumerna_cena_potraviny) OVER (PARTITION BY nazev_potraviny ORDER BY rok_spolecny) AS cena_predchozi_rok
    FROM t_dominik_voros_project_sql_primary_final
)
SELECT     
nazev_potraviny,
    ROUND(AVG((prumerna_cena_potraviny - cena_predchozi_rok) / cena_predchozi_rok * 100)::numeric, 2) AS prumerny_narust_procenta,
    CASE 
        WHEN AVG((prumerna_cena_potraviny - cena_predchozi_rok) / cena_predchozi_rok * 100) > 0.5 THEN 'vyšší'
        WHEN AVG((prumerna_cena_potraviny - cena_predchozi_rok) / cena_predchozi_rok * 100) < 0.1 THEN 'nízký'
        ELSE 'mírný'
    END AS cenovy_trend
FROM mezirocni_zmeny
GROUP BY nazev_potraviny
ORDER BY prumerny_narust_procenta ASC;

--Závěr: Nejpomaleji zdražila přírodní minerální voda uhličitá.
---------------------------------------------------------------------------------------------------------------	
	
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

