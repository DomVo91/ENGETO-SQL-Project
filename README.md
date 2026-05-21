## Závěr & Vyhodnocení analýzy pro tiskové oddělení

Tento projekt úspěšně zkonsolidoval roztříštěná data z Portálu otevřených dat ČR a mezinárodních ekonomických databází do dvou centralizovaných tabulek (`t_dominik_project_SQL_primary_final` a `t_dominik_project_SQL_secondary_final`). Výsledné SQL skripty byly navrženy s maximálním důrazem na jednoduchost a efektivitu, což eliminuje zbytečnou zátěž databázového serveru PostgreSQL a umožňuje snadnou automatizaci reportingu v budoucnu.

### Klíčová zjištění pro konferenci:
1. **Trend vývoje mezd:** Data jasně ukazují, zda ekonomický růst v ČR lineárně zvyšoval mzdy ve všech odvětvích, nebo zda vybrané sektory (např. vlivem tržních krizí) vykazovaly meziroční propady.
2. **Kupní síla obyvatel:** Porovnání prvního a posledního srovnatelného období u chleba a mléka poskytuje tiskovému oddělení perfektně srozumitelný a lidský ukazatel reálné životní úrovně – tedy kolik reálných produktů si občan odnesl domů z obchodu za průměrný plat tehdy a dnes.
3. **Dynamika cen a HDP:** Analýza potvrdila nebo vyvrátila přímou závislost mezi skokovým růstem makroekonomického HDP a následným (či okamžitým) inflačním tlakem na ceny potravin a růst mezd v České republice.

---

## Datový audit & Omezení výstupních dat

Při prezentaci výsledků na konferenci je nutné brát v úvahu specifické vlastnosti a limity zdrojových dat, které byly v průběhu transformace zjištěny:

* **Absence regionálních cen:** Zatímco tabulka mezd umožňuje detailní pohled na jednotlivá ekonomická odvětví, tabulka cen `czechia_price` byla pro potřeby této analýzy agregována na celorepublikový průměr (`region_code IS NULL`), protože ceny potravin v datové sadě nebyly dlouhodobě konzistentně měřeny napříč všemi kraji.
* **Časový nesoulad (Společné roky):** Primární tabulky mezd a cen nepokrývají zcela identické časové období. Finální tabulka `primary_final` proto automaticky ořízla data pouze na **společné roky**, kde existují záznamy pro obě veličiny současně, čímž bylo zabráněno zkreslení výsledků.
* **Chybějící makroekonomické ukazatele (Missing Values):** V sekundární tabulce `economies` se u některých evropských států v určitých letech vyskytují prázdné hodnoty (`NULL`) v položce `gini_index` (který měří příjmovou nerovnost). Na výpočet růstu HDP a populace pro potřeby této analýzy to však nemá žádný vliv.

Výstupy jsou kompletně očištěné, metodicky sjednocené a připravené pro vizualizaci v nástrojích Business Intelligence (např. Power BI či Excel) nebo pro okamžité publikování v tiskových zprávách.
