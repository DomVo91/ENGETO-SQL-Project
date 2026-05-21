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