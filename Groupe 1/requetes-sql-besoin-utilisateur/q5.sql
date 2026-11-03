-- ============================================================================
-- Fichier   : q5.sql
-- Objet     : Requête Q5 (besoin métier) déclinée sur les configurations A0 à A3
-- Moteur    : ClickHouse
-- Version   : 2.0
-- ============================================================================
-- Format : « -- name: Q5_aX » ouvre la requête Q5 sur la configuration AX.
-- Les tables de faits sont lues dans dwh_aX ; les dimensions, identiques partout,
-- sont lues dans dwh_a0 (voir le rapport, section Benchmark).

-- name: Q5_a0
-- Besoin : taux d'hospitalisation par sexe et par âge.
-- Le fichier d'hospitalisation ne porte pas d'identifiant patient : le croisement par sexe
-- et tranche d'âge est fait sur les consultations (voir le rapport).
SELECT p.sexe,
       p.tranche_age,
       count() AS nb_consultations,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a0.fact_consultation c
JOIN dwh_a0.dim_patient p ON p.id_patient = c.id_patient
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY p.sexe, p.tranche_age
ORDER BY p.sexe, p.tranche_age;

-- name: Q5_a1
-- Besoin : taux d'hospitalisation par sexe et par âge.
-- Le fichier d'hospitalisation ne porte pas d'identifiant patient : le croisement par sexe
-- et tranche d'âge est fait sur les consultations (voir le rapport).
SELECT p.sexe,
       p.tranche_age,
       count() AS nb_consultations,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a1.fact_consultation c
JOIN dwh_a0.dim_patient p ON p.id_patient = c.id_patient
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY p.sexe, p.tranche_age
ORDER BY p.sexe, p.tranche_age;

-- name: Q5_a2
-- Besoin : taux d'hospitalisation par sexe et par âge.
-- Le fichier d'hospitalisation ne porte pas d'identifiant patient : le croisement par sexe
-- et tranche d'âge est fait sur les consultations (voir le rapport).
SELECT p.sexe,
       p.tranche_age,
       count() AS nb_consultations,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a2.fact_consultation c
JOIN dwh_a0.dim_patient p ON p.id_patient = c.id_patient
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY p.sexe, p.tranche_age
ORDER BY p.sexe, p.tranche_age;

-- name: Q5_a3
-- Besoin : taux d'hospitalisation par sexe et par âge.
-- Le fichier d'hospitalisation ne porte pas d'identifiant patient : le croisement par sexe
-- et tranche d'âge est fait sur les consultations (voir le rapport).
SELECT p.sexe,
       p.tranche_age,
       count() AS nb_consultations,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a3.fact_consultation c
JOIN dwh_a0.dim_patient p ON p.id_patient = c.id_patient
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY p.sexe, p.tranche_age
ORDER BY p.sexe, p.tranche_age;
