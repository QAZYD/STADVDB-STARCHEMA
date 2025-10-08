
USE data_warehouse;

INSERT INTO dimUsers (
    source_user_id,
    username,
    first_name,
    last_name,
    address_1,
    address_2,
    city,
    country,
    zip_code,
    phone_number,
    date_of_birth,
    gender,
    created_at,
    updated_at
)
SELECT
    s.user_id AS source_user_id,
    TRIM(s.username) AS username,
    TRIM(s.first_name) AS first_name,
    TRIM(s.last_name) AS last_name,
    TRIM(s.address_1) AS address_1,
    TRIM(s.address_2) AS address_2,
    TRIM(s.city) AS city,
    TRIM(s.country) AS country,
    TRIM(s.zip_code) AS zip_code,
    TRIM(s.phone_number) AS phone_number,

    -- Convert and clean date_of_birth (string → DATE)
    CASE
        WHEN s.date_of_birth REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN STR_TO_DATE(s.date_of_birth, '%Y-%m-%d')
        WHEN s.date_of_birth REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
        THEN STR_TO_DATE(s.date_of_birth, '%m/%d/%Y')
        ELSE NULL
    END AS date_of_birth,

    -- Normalize gender values
    CASE
        WHEN LOWER(TRIM(s.gender)) IN ('m', 'male') THEN 'Male'
        WHEN LOWER(TRIM(s.gender)) IN ('f', 'female') THEN 'Female'
        ELSE 'Unknown'
    END AS gender,

    s.created_at,
    s.updated_at
FROM staging.stg_users s
WHERE s.user_id IS NOT NULL;
