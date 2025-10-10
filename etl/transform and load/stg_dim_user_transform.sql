INSERT INTO data_warehouse.dimUsers (
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
    user_id AS source_user_id,
    TRIM(username) AS username,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,
    NULLIF(TRIM(address_1), '') AS address_1,
    NULLIF(TRIM(address_2), '') AS address_2,
    TRIM(city) AS city,
    TRIM(country) AS country,
    NULLIF(TRIM(zip_code), '') AS zip_code,
    TRIM(phone_number) AS phone_number,
    CASE
        WHEN date_of_birth LIKE '%/%/%'
            THEN STR_TO_DATE(date_of_birth, '%m/%d/%Y')
        WHEN date_of_birth LIKE '%-%-%'
            THEN STR_TO_DATE(date_of_birth, '%Y-%m-%d')
        ELSE NULL
    END AS date_of_birth,
    LOWER(TRIM(gender)) AS gender,
    created_at,
    updated_at
FROM staging.stg_users
WHERE user_id IS NOT NULL;
