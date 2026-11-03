-- ============================================================================
-- Fichier   : q1.sql
-- Objet     : Requête Q1 (besoin métier) déclinée sur les configurations A0 à A3
-- Moteur    : ClickHouse
-- Version   : 2.4
-- ============================================================================
-- Format : « -- name: Q1_aX » ouvre la requête Q1 sur la configuration AX.
-- Chemin : fact_consultation.id_prof_sante -> dim_professionnel.id_prof_sante
--          -> dim_professionnel.identifiant_organisation (établissement d'exercice).
-- PRÉREQUIS : la colonne dim_professionnel.identifiant_organisation (issue de
-- bronze.activite_professionnel_sante) doit être ajoutée au modèle et chargée.
-- Exemple d'établissement : F750821092 (le plus fourni en consultations en 2019).

-- name: Q1_a0
-- Besoin : taux de consultation des patients dans un établissement X sur une période Y.
-- Une consultation est rattachée à l'établissement où exerce le professionnel (voir le rapport).
SELECT toStartOfMonth(c.date_consultation) AS mois,
       countIf(p.identifiant_organisation = {etab:String}) AS nb_consultations_etab,
       count() AS nb_consultations_total,
       round(100 * nb_consultations_etab / nb_consultations_total, 2) AS taux_pct
FROM dwh_a0.fact_consultation c
LEFT JOIN dwh_a0.dim_professionnel p ON p.id_prof_sante = c.id_prof_sante
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY mois
ORDER BY mois;

-- name: Q1_a1
-- Besoin : taux de consultation des patients dans un établissement X sur une période Y.
-- Une consultation est rattachée à l'établissement où exerce le professionnel (voir le rapport).
SELECT toStartOfMonth(c.date_consultation) AS mois,
       countIf(p.identifiant_organisation = {etab:String}) AS nb_consultations_etab,
       count() AS nb_consultations_total,
       round(100 * nb_consultations_etab / nb_consultations_total, 2) AS taux_pct
FROM dwh_a1.fact_consultation c
LEFT JOIN dwh_a0.dim_professionnel p ON p.id_prof_sante = c.id_prof_sante
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY mois
ORDER BY mois;

-- name: Q1_a2
-- Besoin : taux de consultation des patients dans un établissement X sur une période Y.
-- Une consultation est rattachée à l'établissement où exerce le professionnel (voir le rapport).
SELECT toStartOfMonth(c.date_consultation) AS mois,
       countIf(p.identifiant_organisation = {etab:String}) AS nb_consultations_etab,
       count() AS nb_consultations_total,
       round(100 * nb_consultations_etab / nb_consultations_total, 2) AS taux_pct
FROM dwh_a2.fact_consultation c
LEFT JOIN dwh_a0.dim_professionnel p ON p.id_prof_sante = c.id_prof_sante
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY mois
ORDER BY mois;

-- name: Q1_a3
-- Besoin : taux de consultation des patients dans un établissement X sur une période Y.
-- Une consultation est rattachée à l'établissement où exerce le professionnel (voir le rapport).
SELECT toStartOfMonth(c.date_consultation) AS mois,
       countIf(p.identifiant_organisation = {etab:String}) AS nb_consultations_etab,
       count() AS nb_consultations_total,
       round(100 * nb_consultations_etab / nb_consultations_total, 2) AS taux_pct
FROM dwh_a3.fact_consultation c
LEFT JOIN dwh_a0.dim_professionnel p ON p.id_prof_sante = c.id_prof_sante
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY mois
ORDER BY mois;
