-- ============================================================================
-- Fichier   : q2.sql
-- Objet     : Requête Q2 (besoin métier) déclinée sur les configurations A0 à A3
-- Moteur    : ClickHouse
-- Version   : 2.0
-- ============================================================================
-- Format : « -- name: Q2_aX » ouvre la requête Q2 sur la configuration AX.
-- Les tables de faits sont lues dans dwh_aX ; les dimensions, identiques partout,
-- sont lues dans dwh_a0 (voir le rapport, section Benchmark).

-- name: Q2_a0
-- Besoin : taux de consultation des patients par rapport à un diagnostic X sur une période Y.
-- Chaque diagnostic avec son nombre de consultations et sa part (%) dans le total de la période.
SELECT d.diagnostic,
       count() AS nb_consultations,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a0.fact_consultation c
JOIN dwh_a0.dim_diagnostic d ON d.code_diag = c.code_diag
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY d.diagnostic
ORDER BY nb_consultations DESC, d.diagnostic;

-- name: Q2_a1
-- Besoin : taux de consultation des patients par rapport à un diagnostic X sur une période Y.
-- Chaque diagnostic avec son nombre de consultations et sa part (%) dans le total de la période.
SELECT d.diagnostic,
       count() AS nb_consultations,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a1.fact_consultation c
JOIN dwh_a0.dim_diagnostic d ON d.code_diag = c.code_diag
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY d.diagnostic
ORDER BY nb_consultations DESC, d.diagnostic;

-- name: Q2_a2
-- Besoin : taux de consultation des patients par rapport à un diagnostic X sur une période Y.
-- Chaque diagnostic avec son nombre de consultations et sa part (%) dans le total de la période.
SELECT d.diagnostic,
       count() AS nb_consultations,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a2.fact_consultation c
JOIN dwh_a0.dim_diagnostic d ON d.code_diag = c.code_diag
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY d.diagnostic
ORDER BY nb_consultations DESC, d.diagnostic;

-- name: Q2_a3
-- Besoin : taux de consultation des patients par rapport à un diagnostic X sur une période Y.
-- Chaque diagnostic avec son nombre de consultations et sa part (%) dans le total de la période.
SELECT d.diagnostic,
       count() AS nb_consultations,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a3.fact_consultation c
JOIN dwh_a0.dim_diagnostic d ON d.code_diag = c.code_diag
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY d.diagnostic
ORDER BY nb_consultations DESC, d.diagnostic;
