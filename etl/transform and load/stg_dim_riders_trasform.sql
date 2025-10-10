INSERT INTO data_warehouse.dimRiders (
    rider_id,
    first_name,
    last_name,
    vehicle_type,
    counter_id,
    age,
    gender,
    created_at,
    updated_at
)
SELECT
    rider_id,
    CONCAT(UPPER(LEFT(TRIM(first_name), 1)), LOWER(SUBSTRING(TRIM(first_name), 2))) AS first_name,
    CONCAT(UPPER(LEFT(TRIM(last_name), 1)), LOWER(SUBSTRING(TRIM(last_name), 2))) AS last_name,
    CONCAT(UPPER(LEFT(TRIM(vehicle_type), 1)), LOWER(SUBSTRING(TRIM(vehicle_type), 2))) AS vehicle_type,
    counter_id,
    CASE
        WHEN age < 0 OR age IS NULL THEN NULL
        ELSE age
    END AS age,
    LOWER(TRIM(gender)) AS gender,
    created_at,
    updated_at
FROM staging.stg_riders
WHERE rider_id IS NOT NULL;
