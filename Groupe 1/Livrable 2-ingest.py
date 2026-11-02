
"""
INGESTION BRONZE
PostgreSQL + CSV -> Iceberg / S3

- Lecture des sources
- Sélection des colonnes autorisées
- Exclusion des colonnes sensibles
- Généralisation des dates par décennies
- Généralisation des lieux par département
- Généralisation des âges par tranches
- Pseudonymisation (HMAC-SHA256, clé ENCRYPTION_KEY) des identifiants patient
- Ecriture dans Iceberg

Aucune normalisation des noms de colonnes.
"""

import hashlib
import hmac
import os

from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import StringType


# ==================================================
# 1. CONFIGURATION CSV
# ==================================================

RAW = "s3a://raw"

CSV_SOURCES = [
    ("DECES EN FRANCE/deces.csv", ",", "UTF-8", "deces"),
    ("Etablissement de SANTE/etablissement_sante.csv", ";", "UTF-8", "etablissement_sante"),
    ("Etablissement de SANTE/professionnel_sante.csv", ";", "ISO-8859-1", "professionnel_sante"),
    ("Etablissement de SANTE/activite_professionnel_sante.csv", ";", "UTF-8", "activite_professionnel_sante"),
    ("Hospitalisation/Hospitalisations.csv", ";", "UTF-8", "hospitalisations"),
    ("Satisfaction/2019/resultats-esatis48h-mco-open-data-2019.csv", ";", "ISO-8859-1", "satisfaction_esatis48h_2019"),
    ("Satisfaction/2019/resultats-esatisca-mco-open-data-2019.csv", ";", "ISO-8859-1", "satisfaction_esatisca_2019"),
    ("Satisfaction/2019/resultats-iqss-open-data-2019.csv", ";", "ISO-8859-1", "satisfaction_iqss_2019"),
]


# ==================================================
# 2. COLONNES A EXCLURE
# ==================================================

EXCLUDED_COLUMNS = {

    # CSV
    "deces": [
        "nom",
        "prénom",
        "lieu_naissance",
        "numéro_acte_deces",
    ],

    "professionnel_sante": [
        "nom",
        "prénom",
        "commune",
    ],

    "hospitalisations": [
        "Id_patient",
    ],

    # PostgreSQL
    "Patient": [
        "Nom",
        "Prenom",
        "Adresse",
        "Ville",
        "Code_postal",
        "EMail",
        "Tel",
        "Date",
        "Num_Secu",
        "Poid",
        "Taille",
    ],

    "Hospitalisations": [
        "Id_patient",
    ],
}


# ==================================================
# 3. COLONNES A TRANSFORMER
# ==================================================

# Les noms sont ceux des colonnes sources, sans modification.

DATE_COLUMNS = {
    "deces": [
        "date_naissance",
        "date_deces",
    ],
}

DEPARTMENT_COLUMNS = {
    "deces": [
        "code_lieu_naissance",
        "code_lieu_deces",
    ],
}

AGE_COLUMNS = {
    "Patient": [
        "Age",
    ],
}


# ==================================================
# 4. CORRESPONDANCE DES DEPARTEMENTS
# ==================================================

DEPARTMENTS = {
    "01": "Ain",
    "02": "Aisne",
    "03": "Allier",
    "04": "Alpes-de-Haute-Provence",
    "05": "Hautes-Alpes",
    "06": "Alpes-Maritimes",
    "07": "Ardèche",
    "08": "Ardennes",
    "09": "Ariège",
    "10": "Aube",
    "11": "Aude",
    "12": "Aveyron",
    "13": "Bouches-du-Rhône",
    "14": "Calvados",
    "15": "Cantal",
    "16": "Charente",
    "17": "Charente-Maritime",
    "18": "Cher",
    "19": "Corrèze",
    "2A": "Corse-du-Sud",
    "2B": "Haute-Corse",
    "21": "Côte-d'Or",
    "22": "Côtes-d'Armor",
    "23": "Creuse",
    "24": "Dordogne",
    "25": "Doubs",
    "26": "Drôme",
    "27": "Eure",
    "28": "Eure-et-Loir",
    "29": "Finistère",
    "30": "Gard",
    "31": "Haute-Garonne",
    "32": "Gers",
    "33": "Gironde",
    "34": "Hérault",
    "35": "Ille-et-Vilaine",
    "36": "Indre",
    "37": "Indre-et-Loire",
    "38": "Isère",
    "39": "Jura",
    "40": "Landes",
    "41": "Loir-et-Cher",
    "42": "Loire",
    "43": "Haute-Loire",
    "44": "Loire-Atlantique",
    "45": "Loiret",
    "46": "Lot",
    "47": "Lot-et-Garonne",
    "48": "Lozère",
    "49": "Maine-et-Loire",
    "50": "Manche",
    "51": "Marne",
    "52": "Haute-Marne",
    "53": "Mayenne",
    "54": "Meurthe-et-Moselle",
    "55": "Meuse",
    "56": "Morbihan",
    "57": "Moselle",
    "58": "Nièvre",
    "59": "Nord",
    "60": "Oise",
    "61": "Orne",
    "62": "Pas-de-Calais",
    "63": "Puy-de-Dôme",
    "64": "Pyrénées-Atlantiques",
    "65": "Hautes-Pyrénées",
    "66": "Pyrénées-Orientales",
    "67": "Bas-Rhin",
    "68": "Haut-Rhin",
    "69": "Rhône",
    "70": "Haute-Saône",
    "71": "Saône-et-Loire",
    "72": "Sarthe",
    "73": "Savoie",
    "74": "Haute-Savoie",
    "75": "Paris",
    "76": "Seine-Maritime",
    "77": "Seine-et-Marne",
    "78": "Yvelines",
    "79": "Deux-Sèvres",
    "80": "Somme",
    "81": "Tarn",
    "82": "Tarn-et-Garonne",
    "83": "Var",
    "84": "Vaucluse",
    "85": "Vendée",
    "86": "Vienne",
    "87": "Haute-Vienne",
    "88": "Vosges",
    "89": "Yonne",
    "90": "Territoire de Belfort",
    "91": "Essonne",
    "92": "Hauts-de-Seine",
    "93": "Seine-Saint-Denis",
    "94": "Val-de-Marne",
    "95": "Val-d'Oise",
    "971": "Guadeloupe",
    "972": "Martinique",
    "973": "Guyane",
    "974": "La Réunion",
    "976": "Mayotte",
}


# ==================================================
# 5. FONCTION DE GENERALISATION DES DEPARTEMENTS
# ==================================================

def generalize_department(df, column):

    if column not in df.columns:
        return df

    code = F.upper(F.trim(F.col(column).cast("string")))

    department_code = (
        F.when(code.rlike("^2A"), F.lit("2A"))
        .when(code.rlike("^2B"), F.lit("2B"))
        .when(code.rlike("^97[1-6][0-9]{2}$"), F.substring(code, 1, 3))
        .when(code.rlike("^9[0-5][0-9]{3}$"), F.substring(code, 1, 2))
        .when(code.rlike("^[0-9]{5}$"), F.substring(code, 1, 2))
        .when(code.rlike("^[0-9]{2}$"), code)
        .when(code.rlike("^97[1-6]$"), code)
        .otherwise(F.lit(None))
    )

    mapping = F.create_map(
        *[
            value
            for key, value in DEPARTMENTS.items()
            for value in (F.lit(key), F.lit(value))
        ]
    )

    department_name = F.element_at(mapping, department_code)

    return df.withColumn(
        column,
        F.when(
            F.col(column).isNull(),
            F.lit(None).cast("string")
        ).otherwise(
            F.coalesce(
                department_name,
                F.lit("Département non déterminé")
            )
        )
    )


# ==================================================
# 6. FONCTION DE GENERALISATION DES DATES
# ==================================================

def generalize_date(df, column):

    if column not in df.columns:
        return df

    original = F.col(column)
    raw_date = original.cast("string")

    parsed_date = F.coalesce(
        F.try_to_date(raw_date, "yyyy-MM-dd"),
        F.try_to_date(raw_date, "dd/MM/yyyy"),
        F.try_to_date(raw_date, "dd-MM-yyyy"),
        F.try_to_date(raw_date, "yyyyMMdd"),
        F.try_to_date(raw_date, "MM/dd/yyyy"),
        F.try_to_date(raw_date, "yyyy-MM-dd HH:mm:ss"),
        F.try_to_date(raw_date, "dd/MM/yyyy HH:mm:ss"),
    )

    year = F.year(parsed_date)

    start_year = F.floor(year / 10) * 10
    end_year = start_year + 9

    return df.withColumn(
        column,
        F.when(
            original.isNull(),
            F.lit(None).cast("string")
        ).when(
            parsed_date.isNotNull(),
            F.concat(
                start_year.cast("string"),
                F.lit("-"),
                end_year.cast("string")
            )
        ).otherwise(
            F.lit("Date non interprétable")
        )
    )


# ==================================================
# 7. FONCTION DE GENERALISATION DES AGES
# ==================================================

def generalize_age(df, column):

    if column not in df.columns:
        return df

    age = F.col(column).try_cast("int")

    start = (
        F.when(age.between(0, 9), 0)
        .when(age.between(10, 18), 10)
        .when(age.between(19, 30), 19)
        .when(
            age >= 31,
            31 + F.floor((age - 31) / 10) * 10
        )
    )

    end = (
        F.when(age.between(0, 9), 9)
        .when(age.between(10, 18), 18)
        .when(age.between(19, 30), 30)
        .when(age >= 31, start + 9)
    )

    return df.withColumn(
        column,
        F.when(
            F.col(column).isNull(),
            F.lit(None).cast("string")
        ).when(
            age < 0,
            F.lit("Âge non interprétable")
        ).when(
            age.isNull(),
            F.lit("Âge non interprétable")
        ).otherwise(
            F.concat(
                start.cast("string"),
                F.lit("-"),
                end.cast("string"),
                F.lit(" ans")
            )
        )
    )


# ==================================================
# 7b. PSEUDONYMISATION
# ==================================================

# HMAC-SHA256 déterministe : même identifiant -> même pseudonyme dans toutes les tables,
# les jointures restent possibles. Irréversible sans la clé ENCRYPTION_KEY.
PSEUDONYMIZED_COLUMNS = {
    "Patient": ["Id_patient"],
    "Consultation": ["Id_patient"],
    "Adher": ["Id_patient"],
}

_KEY = os.environ["ENCRYPTION_KEY"].encode()


def _hmac(value):
    if value is None:
        return None
    return hmac.new(_KEY, str(value).encode(), hashlib.sha256).hexdigest()


_hmac_udf = F.udf(_hmac, StringType())


def pseudonymize(df, column):
    return df.withColumn(column, _hmac_udf(F.col(column)))


# ==================================================
# 8. SELECTION DES COLONNES AUTORISEES
# ==================================================

def select_allowed_columns(df, table_name):

    excluded = EXCLUDED_COLUMNS.get(table_name, [])

    allowed = [
        column
        for column in df.columns
        if column not in excluded
    ]

    removed = [
        column
        for column in df.columns
        if column in excluded
    ]

    if removed:
        print(
            f"[SECURITE] {table_name} : "
            f"colonnes exclues : {removed}"
        )

    return df.select(*allowed)


# ==================================================
# 9. APPLICATION DES TRANSFORMATIONS
# ==================================================

def apply_transformations(df, table_name):

    for column in DATE_COLUMNS.get(table_name, []):
        df = generalize_date(df, column)

    for column in DEPARTMENT_COLUMNS.get(table_name, []):
        df = generalize_department(df, column)

    for column in AGE_COLUMNS.get(table_name, []):
        df = generalize_age(df, column)

    for column in PSEUDONYMIZED_COLUMNS.get(table_name, []):
        df = pseudonymize(df, column)

    return df


# ==================================================
# 10. INITIALISATION SPARK
# ==================================================

spark = (
    SparkSession.builder
    .appName("ingestion-bronze")
    .getOrCreate()
)

spark.sql(
    "CREATE NAMESPACE IF NOT EXISTS lake.bronze"
)


# ==================================================
# 11. CONNEXION POSTGRESQL
# ==================================================

jdbc = {
    "url": "jdbc:postgresql://postgres:5432/sante",
    "user": "postgres",
    "password": os.environ["POSTGRES_PASSWORD"],
    "driver": "org.postgresql.Driver",
}


# ==================================================
# 12. INGESTION POSTGRESQL
# ==================================================

tables = (
    spark.read.format("jdbc")
    .options(**jdbc)
    .option(
        "query",
        """
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE'
        """
    )
    .load()
    .collect()
)

for row in tables:

    name = row.table_name

    print(f"\n[POSTGRES] Lecture de {name}")

    df = (
        spark.read.format("jdbc")
        .options(**jdbc)
        .option("dbtable", f'public."{name}"')
        .load()
    )

    # 1. Généralisation
    df = apply_transformations(df, name)

    # 2. Exclusion des colonnes sensibles
    df = select_allowed_columns(df, name)

    # 3. Ecriture Iceberg
    # Minuscules : Trino normalise les identifiants et ne retrouve pas les tables Nessie en casse mixte
    target = f"lake.bronze.`pg_{name.lower()}`"

    df.writeTo(target).createOrReplace()

    print(f"[OK] PostgreSQL : {name}")


# ==================================================
# 13. INGESTION CSV
# ==================================================

for path, sep, enc, table in CSV_SOURCES:

    print(f"\n[CSV] Lecture de {path}")

    df = (
        spark.read
        .option("header", True)
        .option("sep", sep)
        .option("encoding", enc)
        .option("multiLine", False)
        .option("inferSchema", False)
        .csv(f"{RAW}/{path}")
    )

    # 1. Généralisation
    df = apply_transformations(df, table)

    # 2. Exclusion des colonnes sensibles
    df = select_allowed_columns(df, table)

    # 3. Ecriture Iceberg
    target = f"lake.bronze.{table}"

    df.writeTo(target).createOrReplace()

    print(f"[OK] CSV : {table}")


# ==================================================
# 14. FIN
# ==================================================

print("\n===================================")
print("INGESTION BRONZE TERMINEE")
print("===================================")

spark.stop()
