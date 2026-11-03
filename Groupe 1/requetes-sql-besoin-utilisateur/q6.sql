-- ============================================================================
-- Fichier   : q6.sql
-- Objet     : Requête Q6 (besoin métier) déclinée sur les configurations A0 à A3
-- Moteur    : ClickHouse
-- Version   : 2.0
-- ============================================================================
-- Format : « -- name: Q6_aX » ouvre la requête Q6 sur la configuration AX.
-- Les tables de faits sont lues dans dwh_aX ; les dimensions, identiques partout,
-- sont lues dans dwh_a0 (voir le rapport, section Benchmark).

-- name: Q6_a0
-- Besoin : taux de consultation par professionnel (catégorie et profession) sur une période.
SELECT p.categorie_professionnelle,
       p.profession,
       count() AS nb_consultations,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a0.fact_consultation c
JOIN dwh_a0.dim_professionnel p ON p.id_prof_sante = c.id_prof_sante
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY p.categorie_professionnelle, p.profession
ORDER BY nb_consultations DESC, p.categorie_professionnelle, p.profession;

-- name: Q6_a1
-- Besoin : taux de consultation par professionnel (catégorie et profession) sur une période.
SELECT p.categorie_professionnelle,
       p.profession,
       count() AS nb_consultations,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a1.fact_consultation c
JOIN dwh_a0.dim_professionnel p ON p.id_prof_sante = c.id_prof_sante
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY p.categorie_professionnelle, p.profession
ORDER BY nb_consultations DESC, p.categorie_professionnelle, p.profession;

-- name: Q6_a2
-- Besoin : taux de consultation par professionnel (catégorie et profession) sur une période.
SELECT p.categorie_professionnelle,
       p.profession,
       count() AS nb_consultations,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a2.fact_consultation c
JOIN dwh_a0.dim_professionnel p ON p.id_prof_sante = c.id_prof_sante
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY p.categorie_professionnelle, p.profession
ORDER BY nb_consultations DESC, p.categorie_professionnelle, p.profession;

-- name: Q6_a3
-- Besoin : taux de consultation par professionnel (catégorie et profession) sur une période.
SELECT p.categorie_professionnelle,
       p.profession,
       count() AS nb_consultations,
       round(100 * count() / sum(count()) OVER (), 2) AS taux_pct
FROM dwh_a3.fact_consultation c
JOIN dwh_a0.dim_professionnel p ON p.id_prof_sante = c.id_prof_sante
WHERE c.date_consultation BETWEEN {debut:Date} AND {fin:Date}
GROUP BY p.categorie_professionnelle, p.profession
ORDER BY nb_consultations DESC, p.categorie_professionnelle, p.profession;
