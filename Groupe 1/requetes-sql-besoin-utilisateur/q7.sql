-- ============================================================================
-- Fichier   : q7.sql
-- Objet     : Requête Q7 (besoin métier) déclinée sur les configurations A0 à A3
-- Moteur    : ClickHouse
-- Version   : 2.0
-- ============================================================================
-- Format : « -- name: Q7_aX » ouvre la requête Q7 sur la configuration AX.
-- Les tables de faits sont lues dans dwh_aX ; les dimensions, identiques partout,
-- sont lues dans dwh_a0 (voir le rapport, section Benchmark).

-- name: Q7_a0
-- Besoin (optionnel) : nombre de décès par localisation sur l'année 2019.
-- Les dates de décès sont généralisées à la décennie (RGPD) : 2019 est lue dans la décennie 2010.
-- L'entrepôt n'a pas de table de localisation : la localisation retenue est le département.
SELECT departement_deces,
       count() AS nb_deces,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct,
       avg(age_approx) AS age_moyen_approx
FROM dwh_a0.fact_deces
WHERE decennie_deces = 2010
GROUP BY departement_deces
ORDER BY nb_deces DESC, departement_deces;

-- name: Q7_a1
-- Besoin (optionnel) : nombre de décès par localisation sur l'année 2019.
-- Les dates de décès sont généralisées à la décennie (RGPD) : 2019 est lue dans la décennie 2010.
-- L'entrepôt n'a pas de table de localisation : la localisation retenue est le département.
SELECT departement_deces,
       count() AS nb_deces,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct,
       avg(age_approx) AS age_moyen_approx
FROM dwh_a1.fact_deces
WHERE decennie_deces = 2010
GROUP BY departement_deces
ORDER BY nb_deces DESC, departement_deces;

-- name: Q7_a2
-- Besoin (optionnel) : nombre de décès par localisation sur l'année 2019.
-- Les dates de décès sont généralisées à la décennie (RGPD) : 2019 est lue dans la décennie 2010.
-- L'entrepôt n'a pas de table de localisation : la localisation retenue est le département.
SELECT departement_deces,
       count() AS nb_deces,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct,
       avg(age_approx) AS age_moyen_approx
FROM dwh_a2.fact_deces
WHERE decennie_deces = 2010
GROUP BY departement_deces
ORDER BY nb_deces DESC, departement_deces;

-- name: Q7_a3
-- Besoin (optionnel) : nombre de décès par localisation sur l'année 2019.
-- Les dates de décès sont généralisées à la décennie (RGPD) : 2019 est lue dans la décennie 2010.
-- L'entrepôt n'a pas de table de localisation : la localisation retenue est le département.
SELECT departement_deces,
       count() AS nb_deces,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct,
       avg(age_approx) AS age_moyen_approx
FROM dwh_a3.fact_deces
WHERE decennie_deces = 2010
GROUP BY departement_deces
ORDER BY nb_deces DESC, departement_deces;
