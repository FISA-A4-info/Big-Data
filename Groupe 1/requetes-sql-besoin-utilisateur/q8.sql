-- ============================================================================
-- Fichier   : q8.sql
-- Objet     : Requête Q8 (besoin métier) déclinée sur les configurations A0 à A3
-- Moteur    : ClickHouse
-- Version   : 2.0
-- ============================================================================
-- Format : « -- name: Q8_aX » ouvre la requête Q8 sur la configuration AX.
-- Les tables de faits sont lues dans dwh_aX ; les dimensions, identiques partout,
-- sont lues dans dwh_a0 (voir le rapport, section Benchmark).

-- name: Q8_a0
-- Besoin (optionnel) : taux global de satisfaction par région sur l'année 2020.
-- Score moyen simple et score moyen pondéré par le nombre de réponses.
-- fact_satisfaction n'a pas de colonne année : la table contient une seule campagne
-- d'enquête, donc pas de filtre sur 2020 (voir le rapport).
SELECT region,
       count() AS nb_etablissements,
       avg(score_global) AS score_moyen,
       sum(score_global * nb_reponses) / sum(nb_reponses) AS score_moyen_pondere,
       sum(nb_reponses) AS total_reponses
FROM dwh_a0.fact_satisfaction
WHERE score_global IS NOT NULL
GROUP BY region
ORDER BY region;

-- name: Q8_a1
-- Besoin (optionnel) : taux global de satisfaction par région sur l'année 2020.
-- Score moyen simple et score moyen pondéré par le nombre de réponses.
-- fact_satisfaction n'a pas de colonne année : la table contient une seule campagne
-- d'enquête, donc pas de filtre sur 2020 (voir le rapport).
SELECT region,
       count() AS nb_etablissements,
       avg(score_global) AS score_moyen,
       sum(score_global * nb_reponses) / sum(nb_reponses) AS score_moyen_pondere,
       sum(nb_reponses) AS total_reponses
FROM dwh_a1.fact_satisfaction
WHERE score_global IS NOT NULL
GROUP BY region
ORDER BY region;

-- name: Q8_a2
-- Besoin (optionnel) : taux global de satisfaction par région sur l'année 2020.
-- Score moyen simple et score moyen pondéré par le nombre de réponses.
-- fact_satisfaction n'a pas de colonne année : la table contient une seule campagne
-- d'enquête, donc pas de filtre sur 2020 (voir le rapport).
SELECT region,
       count() AS nb_etablissements,
       avg(score_global) AS score_moyen,
       sum(score_global * nb_reponses) / sum(nb_reponses) AS score_moyen_pondere,
       sum(nb_reponses) AS total_reponses
FROM dwh_a2.fact_satisfaction
WHERE score_global IS NOT NULL
GROUP BY region
ORDER BY region;

-- name: Q8_a3
-- Besoin (optionnel) : taux global de satisfaction par région sur l'année 2020.
-- Score moyen simple et score moyen pondéré par le nombre de réponses.
-- fact_satisfaction n'a pas de colonne année : la table contient une seule campagne
-- d'enquête, donc pas de filtre sur 2020 (voir le rapport).
SELECT region,
       count() AS nb_etablissements,
       avg(score_global) AS score_moyen,
       sum(score_global * nb_reponses) / sum(nb_reponses) AS score_moyen_pondere,
       sum(nb_reponses) AS total_reponses
FROM dwh_a3.fact_satisfaction
WHERE score_global IS NOT NULL
GROUP BY region
ORDER BY region;
