ALTER TABLE "dft-road-casualty-statistics-casualty-2023" RENAME TO casualties;
ALTER TABLE "dft-road-casualty-statistics-collision-2023" RENAME TO collisions;
ALTER TABLE "dft-road-casualty-statistics-vehicle-2023" RENAME TO vehicles;

DROP TABLE accident_severity_variables;

CREATE TABLE accident_severity_variables AS
SELECT
	collisions.accident_severity,
	casualties.casualty_home_area_type,
	collisions.day_of_week,
	collisions.first_road_class,
	collisions.road_type,
	collisions.speed_limit,
	collisions.junction_detail,
	collisions.junction_control,
	collisions.light_conditions,
	collisions.weather_conditions,
	collisions.road_surface_conditions,
	vehicles.vehicle_type,
	vehicles.journey_purpose_of_driver,
	vehicles.sex_of_driver,
	vehicles.age_of_driver,
	vehicles.engine_capacity_cc,
	vehicles.age_of_vehicle
FROM casualties
JOIN collisions ON casualties.accident_reference = collisions.accident_reference
JOIN vehicles ON collisions.accident_reference = vehicles.accident_reference
WHERE
    collisions.accident_severity != -1 AND
    collisions.day_of_week != -1 AND
    collisions.first_road_class != -1 AND
    collisions.road_type != -1 AND
	collisions.road_type != 9 AND
    collisions.speed_limit != -1 AND
	collisions.speed_limit != 99 AND
    collisions.junction_detail != -1 AND
	collisions.junction_detail != 99 AND
    collisions.junction_control != -1 AND
	collisions.junction_control != 9 AND
    collisions.light_conditions != -1 AND
    collisions.weather_conditions != -1 AND
	collisions.weather_conditions != 8 AND
	collisions.weather_conditions != 9 AND
    collisions.road_surface_conditions != -1 AND
	collisions.road_surface_conditions != 9 AND
	casualties.casualty_home_area_type != -1 AND
    vehicles.vehicle_type != -1 AND
    vehicles.journey_purpose_of_driver != -1 AND
	vehicles.journey_purpose_of_driver != 6 AND
	vehicles.journey_purpose_of_driver != 15 AND
    vehicles.sex_of_driver != -1 AND
	vehicles.sex_of_driver != 3 AND
    vehicles.age_of_driver != -1 AND
    vehicles.engine_capacity_cc != -1 AND
    vehicles.age_of_vehicle != -1;