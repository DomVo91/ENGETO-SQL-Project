-- Otázka 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
SELECT 
	rok_spolecny, 
	nazev_potraviny,
	round(AVG(prumerna_mzda)/AVG(prumerna_cena_potraviny)) AS kupni_cena
FROM t_dominik_voros_project_sql_primary_final AS tdvpspf
WHERE rok_spolecny IN (2006, 2018)
AND (nazev_potraviny ILIKE 'Chléb%' OR  nazev_potraviny ILIKE 'Mléko%')
GROUP BY nazev_potraviny, rok_spolecny;
