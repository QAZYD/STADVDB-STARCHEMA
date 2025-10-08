INSERT INTO dimRiders (
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
    first_name,
    last_name,
    vehicle_type,
    counter_id,
    age,
    gender,
    created_at,
    updated_at
FROM stg_riders;
