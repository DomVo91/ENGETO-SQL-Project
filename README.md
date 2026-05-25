# Projekt SQL: Analýza životní úrovně a dostupnosti potravin v ČR

## Úvod projektu
Tento projekt vznikl v analytickém oddělení nezávislé společnosti, která se zabývá výzkumem životní úrovně občanů. Hlavním cílem je poskytnout robustní datové podklady pro tiskové oddělení, které bude výsledky prezentovat na nadcházející konferenci věnované sociálně-ekonomickým otázkám a dostupnosti základních potravin široké veřejnosti. Projekt se zaměřuje na analýzu porovnání dostupnosti potravin na základě průměrných příjmů obyvatel České republiky v definovaném časovém období. Jako doplňkový materiál pro širší kontext je součástí projektu také analýza makroekonomických ukazatelů (HDP, GINI koeficient a populace) dalších evropských států.

---

## Datové sady a zdroje

Pro výpočty byly sjednoceny a transformovány následující datové podklady:

### Primární data pro ČR:
*   **czechia_payroll** – Informace o mzdách v různých odvětvích v ČR (Portál otevřených dat ČR).
*   **czechia_price** – Informace o cenách vybraných potravin v ČR (Portál otevřených dat ČR).
*   **Číselníky:** czechia_payroll_industry_branch (odvětví), czechia_price_category (kategorie potravin).

### Dodatečná data pro mezinárodní srovnání:
*   **countries** – Obecné a geografické informace o státech světa.
*   **economies** – Makroekonomické ukazatele (HDP, GINI koeficient, populace) za jednotlivé státy a roky.

---

## Definované výzkumné otázky
1. **Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**
Mzdy v průběhu let nominálně rostou ve všech odvětvích. Dlouhodobě rostou všude, ale krátkodobě (meziročně) vlivem hospodářských cyklů v konkrétních odvětvích mzdy klesají, což se nejvýrazněji projevilo kolem roku 2013 a to konkrétně v těžbě a dobývání, výroby a rozvodu elektřiny a peněžnictví a pojišťovnictví.
2. **Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**
V prvním a posledním srovnatelném období (roky 2006 a 2018) došlo ke zvýšení kupní síly obyvatelstva u obou sledovaných základních potravin. Průměrný občan si mohl ze své měsíční mzdy pořídit výrazně více litrů mléka i kilogramů chleba.
V roce 2006 bylo možné si koupit 1460 l mléka a 1308 kg chleba, zatímco v roce 2018 to bylo 1667 l mléka a 1363 kg chleba. 
3. **Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?**
Nejpomaleji zdražující kategorií (respektive kategorií s nejnižším průměrným meziročním nárůstem cen) je Cukr krystalový.
4. **Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?**
Analýza dat ukázala, že ve sledovaném období neexistuje žádný rok, kdy by nárůst cen potravin překonal růst mezd o více než 10 %. Nejblíže k negativnímu extrému měl rok 2013, kdy ceny potravin utekly mzdám o 6,59 % (ceny potravin +5,10 %, mzdy -1,49 %). Naopak nejlepším obdobím pro peněženky byl rok 2009, kdy mzdy porazily ceny potravin o 9,50 % díky poklesu cen jídla o -6,41 %. Sledovaná data tak potvrzují, mzdový a cenový vývoj byl stabilní a k žádnému drastickému propadu kupní síly nad 10 % nedošlo.
5. **Má výška HDP vliv na změny ve mzdách a cenách potravin? (Projevuje se růst HDP výraznějším růstem mezd či cen ve stejném nebo následujícím roce?)**
Na základě provedené datové analýzy nelze jednoznačně tvrdit, že by výše HDP měla přímý, okamžitý a předvídatelný vliv na změny cen potravin a mezd. Pokud HDP v jednom roce výrazně vzroste, neprojeví se to automaticky ani ve stejném, ani v následujícím roce fixním nebo výraznějším růstem těchto ukazatelů. Ekonomické veličiny vykazují značnou volatilitu a v různých obdobích se chovají odlišně.

---

## Struktura finálních výstupních tabulek
Pro potřeby analýzy byly v databázi vytvořeny dvě centralizované tabulky, které sjednocují data na totožné porovnatelné období:
*   **t_dominik_project_SQL_primary_final**: Sjednocená a agregovaná data mezd a cen potravin za Českou republiku.
*   **t_dominik_project_SQL_secondary_final**: Dodatečná ekonomická data o dalších evropských státech.
Vysvětlení struktury úvodu:

## Závěr & Vyhodnocení analýzy pro tiskové oddělení

Tento projekt úspěšně zkonsolidoval roztříštěná data z Portálu otevřených dat ČR a mezinárodních ekonomických databází do dvou centralizovaných tabulek (`t_dominik_project_SQL_primary_final` a `t_dominik_project_SQL_secondary_final`). Výsledné SQL skripty byly navrženy s maximálním důrazem na jednoduchost a efektivitu, což eliminuje zbytečnou zátěž databázového serveru PostgreSQL a umožňuje snadnou automatizaci reportingu v budoucnu.

### Klíčové highlights pro tiskové oddělení: 
1. **Platy dlouhodobě rostly, krize je ale zmrazila** – Ekonomický růst sice platy stabilně zvyšoval, ale v krizovém roce 2013 přišel tvrdý náraz a průměrné platy lidem meziročně klesly o 1,49 % (skript otázky 4).
2. **Kupní síla výrazně stoupla** – Životní úroveň v ČR za sledované období viditelně vzrostla. Za průměrný plat si dnes z obchodu odneseme o 300 kg více chleba a o 500 litrů více mléka než v minulosti.
3. **Ceny potravin se neřídí mírou HDP** – Úspěch ekonomiky neurčuje ceny v regálech. Například v roce 2015 ekonomika šlapala, ale jídlo zlevnilo. V krizi roku 2012 naopak ekonomika padala, lidem klesaly platy, ale potraviny přesto drasticky zdražovaly.
4. **Žádný cenový šok se nekonal** – Ani v nejhorším roce (2013) neodskočily ceny jídla od růstu platů o více než 6,59 %. Hranice 10 %, která by znamenala drastické zchudnutí obyvatel, nebyla nikdy překročena.
---

## Datový audit & Omezení výstupních dat

Při prezentaci výsledků na konferenci je nutné brát v úvahu specifické vlastnosti a limity zdrojových dat, které byly v průběhu transformace zjištěny:

* **Absence regionálních cen:** Zatímco tabulka mezd umožňuje detailní pohled na jednotlivá ekonomická odvětví, tabulka cen `czechia_price` byla pro potřeby této analýzy agregována na celorepublikový průměr (`region_code IS NULL`), protože ceny potravin v datové sadě nebyly dlouhodobě konzistentně měřeny napříč všemi kraji.
* **Časový nesoulad (Společné roky):** Primární tabulky mezd a cen nepokrývají zcela identické časové období. Finální tabulka `primary_final` proto automaticky ořízla data pouze na **společné roky**, kde existují záznamy pro obě veličiny současně, čímž bylo zabráněno zkreslení výsledků.
* **Chybějící makroekonomické ukazatele (Missing Values):** V sekundární tabulce `economies` se u některých evropských států v určitých letech vyskytují prázdné hodnoty (`NULL`) v položce `gini_index` (který měří příjmovou nerovnost). Na výpočet růstu HDP a populace pro potřeby této analýzy to však nemá žádný vliv.

Výstupy jsou kompletně očištěné, metodicky sjednocené a připravené pro vizualizaci v nástrojích Business Intelligence (např. Power BI či Excel) nebo pro okamžité publikování v tiskových zprávách.
