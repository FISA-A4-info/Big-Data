-- ============================================================================
-- Fichier   : q3.sql
-- Objet     : Requête Q3 (besoin métier) déclinée sur les configurations A0 à A3
-- Moteur    : ClickHouse
-- Version   : 2.0
-- ============================================================================
-- Format : « -- name: Q3_aX » ouvre la requête Q3 sur la configuration AX.
-- Les tables de faits sont lues dans dwh_aX ; les dimensions, identiques partout,
-- sont lues dans dwh_a0 (voir le rapport, section Benchmark).

-- name: Q3_a0
-- Besoin : taux global d'hospitalisation des patients sur une période Y.
-- Séjours par mois, part (%) de chaque mois dans le total de la période, durée moyenne.
SELECT toStartOfMonth(date_entree) AS mois,
       count() AS nb_sejours,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct,
       avg(duree_jours) AS duree_moyenne
FROM dwh_a0.fact_hospitalisation
WHERE date_entree BETWEEN {debut:Date} AND {fin:Date}
GROUP BY mois
ORDER BY mois;

-- name: Q3_a1
-- Besoin : taux global d'hospitalisation des patients sur une période Y.
-- Séjours par mois, part (%) de chaque mois dans le total de la période, durée moyenne.
SELECT toStartOfMonth(date_entree) AS mois,
       count() AS nb_sejours,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct,
       avg(duree_jours) AS duree_moyenne
FROM dwh_a1.fact_hospitalisation
WHERE date_entree BETWEEN {debut:Date} AND {fin:Date}
GROUP BY mois
ORDER BY mois;

-- name: Q3_a2
-- Besoin : taux global d'hospitalisation des patients sur une période Y.
-- Séjours par mois, part (%) de chaque mois dans le total de la période, durée moyenne.
SELECT toStartOfMonth(date_entree) AS mois,
       count() AS nb_sejours,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct,
       avg(duree_jours) AS duree_moyenne
FROM dwh_a2.fact_hospitalisation
WHERE date_entree BETWEEN {debut:Date} AND {fin:Date}
GROUP BY mois
ORDER BY mois;

-- name: Q3_a3
-- Besoin : taux global d'hospitalisation des patients sur une période Y.
-- Séjours par mois, part (%) de chaque mois dans le total de la période, durée moyenne.
SELECT toStartOfMonth(date_entree) AS mois,
       count() AS nb_sejours,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct,
       avg(duree_jours) AS duree_moyenne
FROM dwh_a3.fact_hospitalisation
WHERE date_entree BETWEEN {debut:Date} AND {fin:Date}
GROUP BY mois
ORDER BY mois;
