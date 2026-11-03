-- ============================================================================
-- Fichier   : q4.sql
-- Objet     : Requête Q4 (besoin métier) déclinée sur les configurations A0 à A3
-- Moteur    : ClickHouse
-- Version   : 2.0
-- ============================================================================
-- Format : « -- name: Q4_aX » ouvre la requête Q4 sur la configuration AX.
-- Les tables de faits sont lues dans dwh_aX ; les dimensions, identiques partout,
-- sont lues dans dwh_a0 (voir le rapport, section Benchmark).

-- name: Q4_a0
-- Besoin : taux d'hospitalisation des patients par rapport à des diagnostics sur une période.
SELECT d.diagnostic,
       count() AS nb_sejours,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a0.fact_hospitalisation h
JOIN dwh_a0.dim_diagnostic d ON d.code_diag = h.code_diag
WHERE h.date_entree BETWEEN {debut:Date} AND {fin:Date}
GROUP BY d.diagnostic
ORDER BY nb_sejours DESC, d.diagnostic;

-- name: Q4_a1
-- Besoin : taux d'hospitalisation des patients par rapport à des diagnostics sur une période.
SELECT d.diagnostic,
       count() AS nb_sejours,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a1.fact_hospitalisation h
JOIN dwh_a0.dim_diagnostic d ON d.code_diag = h.code_diag
WHERE h.date_entree BETWEEN {debut:Date} AND {fin:Date}
GROUP BY d.diagnostic
ORDER BY nb_sejours DESC, d.diagnostic;

-- name: Q4_a2
-- Besoin : taux d'hospitalisation des patients par rapport à des diagnostics sur une période.
SELECT d.diagnostic,
       count() AS nb_sejours,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a2.fact_hospitalisation h
JOIN dwh_a0.dim_diagnostic d ON d.code_diag = h.code_diag
WHERE h.date_entree BETWEEN {debut:Date} AND {fin:Date}
GROUP BY d.diagnostic
ORDER BY nb_sejours DESC, d.diagnostic;

-- name: Q4_a3
-- Besoin : taux d'hospitalisation des patients par rapport à des diagnostics sur une période.
SELECT d.diagnostic,
       count() AS nb_sejours,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a3.fact_hospitalisation h
JOIN dwh_a0.dim_diagnostic d ON d.code_diag = h.code_diag
WHERE h.date_entree BETWEEN {debut:Date} AND {fin:Date}
GROUP BY d.diagnostic
ORDER BY nb_sejours DESC, d.diagnostic;
