CREATE TABLE t_dominik_voros_project_sql_primary_final AS
WITH tabulka_potravin AS (
    SELECT
        cpc.name AS nazev_potraviny, 
        ROUND(AVG(cp.value)::NUMERIC, 2) AS prumerna_cena_potraviny,  
        EXTRACT(YEAR FROM cp.date_from) AS rok_spolecny,
        cpc.price_value AS hodnota,
        cpc.price_unit AS jednotka
    FROM czechia_price cp
    JOIN czechia_price_category cpc ON cp.category_code = cpc.code
    WHERE cp.region_code IS NULL -- Nejjednodušší: bereme průměr za celou ČR (v datech jako NULL)
    GROUP BY cpc.name, cpc.price_value, cpc.price_unit, rok_spolecny
),
tabulka_mezd AS (
    SELECT 
        cpib.name AS nazev_odvetvi,  
        ROUND(AVG(cp.value)::NUMERIC, 0) AS prumerna_mzda,
        cp.payroll_year AS rok_spolecny
    FROM czechia_payroll cp
    LEFT JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code  
    WHERE cp.value_type_code = 5958 -- Průměrná hrubá mzda na zaměstnance
    AND cp.calculation_code = 200  -- Přepočtený počet (full-time equivalent)
    GROUP BY cpib.name, cp.payroll_year
)
SELECT 
    tp.rok_spolecny,
    tp.nazev_potraviny,
    tp.prumerna_cena_potraviny,
    tp.hodnota,
    tp.jednotka,
    tm.nazev_odvetvi,
    tm.prumerna_mzda,
    e.gdp AS hdp_v_roce
FROM tabulka_potravin tp
JOIN tabulka_mezd tm ON tp.rok_spolecny = tm.rok_spolecny
LEFT JOIN economies e ON tp.rok_spolecny = e.year AND e.country = 'Czech Republic'
ORDER BY tp.rok_spolecny, tm.nazev_odvetvi, tp.nazev_potraviny;

-- Kontrola výsledku
SELECT *
FROM t_dominik_voros_project_sql_primary_final;


