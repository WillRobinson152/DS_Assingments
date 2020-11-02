SELECT	
	/* Restated Parcel table columns */
	(substr(RE,1,6)||' '||substr(RE,7,4)) AS RE, 
	CASE WHEN mailing_2 NOT NULL THEN (mailing_1||' '||mailing_2)
		ELSE mailing_1 END AS mailing_address, 
	mailing_city, mailing_state, property_use, subdivision, neighborhood, property_value, 
	county_taxable, total_sf, acres,
	/* Columns from Building table */
	building, type_descr, style, class, quality, yr_built, perc_complete, bldng_value, heated_sf,
	/* Restated Sale table columns */
	trans_id, seller, (year||'-'||month||'-'||day) AS sale_date, price,
	/* Columns from Feature table */
	boat_cv, boatcv_avg_grade, boatcv_avg_ppu, boatcv_avg_yr_built, boatcv_total_depreciated,
	carport_ft, carportft_avg_grade, carportft_avg_ppu, carportft_avg_yr_built, carportft_total_depreciated,
	cov_patio, covpatio_avg_grade, covpatio_avg_ppu, covpatio_avg_yr_built, covpatio_total_depreciated,
	deck_ft, deckft_avg_grade, deckft_avg_ppu, deckft_avg_yr_built, deckft_total_depreciated,
	dock, dock_avg_grade, dock_avg_ppu, dock_avg_yr_built, dock_total_depreciated,
	elevator, elevator_avg_grade, elevator_avg_ppu, elevator_avg_yr_built, elevator_total_depreciated,
	fence, fence_avg_grade, fence_avg_ppu, fence_avg_yr_built, fence_total_depreciated,
	fireplace, fireplace_avg_grade, fireplace_avg_ppu, fireplace_avg_yr_built, fireplace_total_depreciated,
	gazebo, gazebo_avg_grade, gazebo_avg_ppu, gazebo_avg_yr_built, gazebo_total_depreciated,
	greenhouse, greenhouse_avg_grade, greenhouse_avg_ppu, greenhouse_avg_yr_built, greenhouse_total_depreciated,
	coop, coop_avg_grade, coop_avg_ppu, coop_avg_yr_built, coop_total_depreciated,
	pool, pool_avg_grade, pool_avg_ppu, pool_avg_yr_built, pool_total_depreciated,
	sauna, sauna_avg_grade, sauna_avg_ppu, sauna_avg_yr_built, sauna_total_depreciated,
	shed, shed_avg_grade, shed_avg_ppu, shed_avg_yr_built, shed_total_depreciated,
	spa, spa_avg_grade, spa_avg_ppu, spa_avg_yr_built, spa_total_depreciated,
	sun_rm, sunrm_avg_grade, sunrm_avg_ppu, sunrm_avg_yr_built, sunrm_total_depreciated,
	/* Select from subarea_totals subquery */
	additions, addition_area, addition_effec, addition_heated,
	balconies, balcony_area, balcony_effec, balcony_heated,
	basement, basement_area, basement_effec, basement_unfinished,
	canopies, canopy_area, canopy_effec, canopy_heated,
	cabanas, cabana_area, cabana_effec, cabana_heated,
	carports, carport_area, carport_effec, carport_heated, carport_detached, carport_unfinished,
	decks, deck_area, deck_effec, deck_heated,
	det_utility, det_utility_area, det_utility_effec, det_utility_heated, det_utility_unfinished,
	dormers, dormer_area, dormer_effec, dormer_heated,
	entry_corr, entry_area, entry_effec, entry_heated,
	finished_attic, attic_area, attic_effec, attic_heated,
	garages, garage_area, garage_effec, garage_heated, garage_detached, garage_unfinished,
	patios, patio_area, patio_effec, patio_heated,
	porches, porch_area, porch_effec, porch_heated, porch_screened, porch_detached, porch_enclosed, porch_unfinished,
	stoops, stoop_area, stoop_effec, stoop_heated,
	storages, storage_area, storage_effec, storage_heated, storage_unfinished,
	upper_stories, upper_story_area, upper_story_effec, upper_story_heated, upper_story_unfinished
FROM
	(SELECT 
		/* Restated Parcel table columns */
		RE, mailing_1, mailing_2, mailing_city, mailing_state, property_use, subdivision, neighborhood, property_value, county_taxable, total_sf, acres,
		/* Columns from Sale table */
		(or_book || '-' || or_page) AS trans_id, seller, 
		CASE WHEN substr(sale_date,3,1) = '/' THEN substr(sale_date,1,2) 
			ELSE ('0'||substr(sale_date,1,1)) END AS month,
		CASE WHEN substr(sale_date,6,1) = '/' THEN substr(sale_date,4,2) 
			WHEN (substr(sale_date,3,1) = '/') AND substr(sale_date,5,1) = '/' THEN ('0'||substr(sale_date,4,1))
			WHEN (substr(sale_date,2,1) = '/') AND substr(sale_date,4,1) = '/' THEN ('0'||substr(sale_date,3,1))
			ELSE substr(sale_date,3,2) END AS day,
		substr(sale_date,-4,4) AS year,	 
		SUM(DISTINCT(price)) AS price
	FROM 
		(
		SELECT 
		/* Columns from Parcel table */
		Parcel.RE, mailing_1, mailing_2, mailing_city, mailing_state, property_use, subdivision, neighborhood, just_val AS property_value, county_taxable, square_feet AS total_sf, acres
		FROM 
			Parcel
		WHERE
			(property_use = 0 OR property_use = 100 OR property_use = 200 OR property_use = 700 OR property_use = 9999)
		) AS parcels_query
	LEFT JOIN Sale
	USING (RE)
	WHERE 
		/* Filter Sale table to remove deed transfers and sales of vacant land */
		improved = 'I' AND price > 1000
	GROUP BY RE, sale_date) AS sales_query
LEFT JOIN
	(
	SELECT 
		RE, 
		/* Columns from Building table */
		Building.building AS building, type_descr, style, class, quality, Building.actual_yr_built AS yr_built, perc_complete, value AS bldng_value, heated_sf
	FROM 
		(
		SELECT 
		/* Columns from Parcel table */
		Parcel.RE, mailing_1, mailing_2, mailing_city, mailing_state, property_use, subdivision, neighborhood, just_val AS property_value, county_taxable, square_feet AS total_sf, acres
		FROM 
			Parcel
		WHERE
			(property_use = 0 OR property_use = 100 OR property_use = 200 OR property_use = 700 OR property_use = 9999)
		)
	LEFT JOIN Building
	USING (RE)
	WHERE 
		Building.building NOT NULL AND (type_descr LIKE 'SFR%' OR type_descr LIKE 'MH %' OR type_descr = 'TOWNHOUSE' OR type_descr = 'CONVERTED RESIDENCE')
	) AS sales_and_buildings
USING (RE)
LEFT JOIN
		(
	SELECT
		RE, 
		building,
		SUM(boat_cv) AS boat_cv,
		ROUND(AVG(boatcv_grade),1) AS boatcv_avg_grade,
		ROUND(AVG(boatcv_area),1) AS boatcv_avg_area,
		ROUND(AVG(boatcv_ppu),1) AS boatcv_avg_ppu,
		ROUND(AVG(boatcv_yr_built),0) AS boatcv_avg_yr_built,
		SUM(boatcv_depreciated_value) AS boatcv_total_depreciated,
		SUM(carport_ft) AS carport_ft,
		ROUND(AVG(carportft_grade),1) AS carportft_avg_grade,
		ROUND(AVG(carportft_area),1) AS carportft_avg_area,
		ROUND(AVG(carportft_ppu),1) AS carportft_avg_ppu,
		ROUND(AVG(carportft_yr_built),0) AS carportft_avg_yr_built,
		SUM(carportft_depreciated_value) AS carportft_total_depreciated,
		SUM(cov_patio) AS cov_patio,
		ROUND(AVG(covpatio_grade),1) AS covpatio_avg_grade,
		ROUND(AVG(covpatio_area),1) AS covpatio_avg_area,
		ROUND(AVG(covpatio_ppu),1) AS covpatio_avg_ppu,
		ROUND(AVG(covpatio_yr_built),0) AS covpatio_avg_yr_built,
		SUM(covpatio_depreciated_value) AS covpatio_total_depreciated,
		SUM(deck_ft) AS deck_ft,
		ROUND(AVG(deckft_grade),1) AS deckft_avg_grade,
		ROUND(AVG(deckft_area),1) AS deckft_avg_area,
		ROUND(AVG(deckft_ppu),1) AS deckft_avg_ppu,
		ROUND(AVG(deckft_yr_built),0) AS deckft_avg_yr_built,
		SUM(deckft_depreciated_value) AS deckft_total_depreciated,
		SUM(dock) AS dock,
		ROUND(AVG(dock_grade),1) AS dock_avg_grade,
		ROUND(AVG(dock_area),1) AS dock_avg_area,
		ROUND(AVG(dock_ppu),1) AS dock_avg_ppu,
		ROUND(AVG(dock_yr_built),0) AS dock_avg_yr_built,
		SUM(dock_depreciated_value) AS dock_total_depreciated,
		SUM(elevator) AS elevator,
		ROUND(AVG(elevator_grade),1) AS elevator_avg_grade,
		ROUND(AVG(elevator_area),1) AS elevator_avg_area,
		ROUND(AVG(elevator_ppu),1) AS elevator_avg_ppu,
		ROUND(AVG(elevator_yr_built),0) AS elevator_avg_yr_built,
		SUM(elevator_depreciated_value) AS elevator_total_depreciated,
		SUM(fence) AS fence,
		ROUND(AVG(fence_grade),1) AS fence_avg_grade,
		ROUND(AVG(fence_area),1) AS fence_avg_area,
		ROUND(AVG(fence_ppu),1) AS fence_avg_ppu,
		ROUND(AVG(fence_yr_built),0) AS fence_avg_yr_built,
		SUM(fence_depreciated_value) AS fence_total_depreciated,
		SUM(fireplace) AS fireplace,
		ROUND(AVG(fireplace_grade),1) AS fireplace_avg_grade,
		ROUND(AVG(fireplace_area),1) AS fireplace_avg_area,
		ROUND(AVG(fireplace_ppu),1) AS fireplace_avg_ppu,
		ROUND(AVG(fireplace_yr_built),0) AS fireplace_avg_yr_built,
		SUM(fireplace_depreciated_value) AS fireplace_total_depreciated,
		SUM(gazebo) AS gazebo,
		ROUND(AVG(gazebo_grade),1) AS gazebo_avg_grade,
		ROUND(AVG(gazebo_area),1) AS gazebo_avg_area,
		ROUND(AVG(gazebo_ppu),1) AS gazebo_avg_ppu,
		ROUND(AVG(gazebo_yr_built),0) AS gazebo_avg_yr_built,
		SUM(gazebo_depreciated_value) AS gazebo_total_depreciated,
		SUM(greenhouse) AS greenhouse,
		ROUND(AVG(greenhouse_grade),1) AS greenhouse_avg_grade,
		ROUND(AVG(greenhouse_area),1) AS greenhouse_avg_area,
		ROUND(AVG(greenhouse_ppu),1) AS greenhouse_avg_ppu,
		ROUND(AVG(greenhouse_yr_built),0) AS greenhouse_avg_yr_built,
		SUM(greenhouse_depreciated_value) AS greenhouse_total_depreciated,
		SUM(coop) AS coop,
		ROUND(AVG(coop_grade),1) AS coop_avg_grade,
		ROUND(AVG(coop_area),1) AS coop_avg_area,
		ROUND(AVG(coop_ppu),1) AS coop_avg_ppu,
		ROUND(AVG(coop_yr_built),0) AS coop_avg_yr_built,
		SUM(coop_depreciated_value) AS coop_total_depreciated,
		SUM(pool) AS pool,
		ROUND(AVG(pool_grade),1) AS pool_avg_grade,
		ROUND(AVG(pool_area),1) AS pool_avg_area,
		ROUND(AVG(pool_ppu),1) AS pool_avg_ppu,
		ROUND(AVG(pool_yr_built),0) AS pool_avg_yr_built,
		SUM(pool_depreciated_value) AS pool_total_depreciated,
		SUM(rball_court) AS rball_court,
		ROUND(AVG(rball_grade),1) AS rball_avg_grade,
		ROUND(AVG(rball_area),1) AS rball_avg_area,
		ROUND(AVG(rball_ppu),1) AS rball_avg_ppu,
		ROUND(AVG(rball_yr_built),0) AS rball_avg_yr_built,
		SUM(rball_depreciated_value) AS rball_total_depreciated,
		SUM(sauna) AS sauna,
		ROUND(AVG(sauna_grade),1) AS sauna_avg_grade,
		ROUND(AVG(sauna_area),1) AS sauna_avg_area,
		ROUND(AVG(sauna_ppu),1) AS sauna_avg_ppu,
		ROUND(AVG(sauna_yr_built),0) AS sauna_avg_yr_built,
		SUM(sauna_depreciated_value) AS sauna_total_depreciated,
		SUM(shed) AS shed,
		ROUND(AVG(shed_grade),1) AS shed_avg_grade,
		ROUND(AVG(shed_area),1) AS shed_avg_area,
		ROUND(AVG(shed_ppu),1) AS shed_avg_ppu,
		ROUND(AVG(shed_yr_built),0) AS shed_avg_yr_built,
		SUM(shed_depreciated_value) AS shed_total_depreciated,
		SUM(spa) AS spa,
		ROUND(AVG(spa_grade),1) AS spa_avg_grade,
		ROUND(AVG(spa_area),1) AS spa_avg_area,
		ROUND(AVG(spa_ppu),1) AS spa_avg_ppu,
		ROUND(AVG(spa_yr_built),0) AS spa_avg_yr_built,
		SUM(spa_depreciated_value) AS spa_total_depreciated,
		SUM(stable) AS stable,
		ROUND(AVG(stable_grade),1) AS stable_avg_grade,
		ROUND(AVG(stable_area),1) AS stable_avg_area,
		ROUND(AVG(stable_ppu),1) AS stable_avg_ppu,
		ROUND(AVG(stable_yr_built),0) AS stable_avg_yr_built,
		SUM(stable_depreciated_value) AS stable_total_depreciated,
		SUM(sun_rm) AS sun_rm,
		ROUND(AVG(sunrm_grade),1) AS sunrm_avg_grade,
		ROUND(AVG(sunrm_area),1) AS sunrm_avg_area,
		ROUND(AVG(sunrm_ppu),1) AS sunrm_avg_ppu,
		ROUND(AVG(sunrm_yr_built),0) AS sunrm_avg_yr_built,
		SUM(sunrm_depreciated_value) AS sunrm_total_depreciated,
		SUM(tennis_ct) AS tennis_ct,
		ROUND(AVG(tennis_grade),1) AS tennis_avg_grade,
		ROUND(AVG(tennis_area),1) AS tennis_avg_area,
		ROUND(AVG(tennis_ppu),1) AS tennis_avg_ppu,
		ROUND(AVG(tennis_yr_built),0) AS tennis_avg_yr_built,
		SUM(tennis_depreciated_value) AS tennis_total_depreciated,
		SUM(other_fts) AS other_fts
	FROM
		(
		SELECT
			RE,
			building,
		-- 	/* Columns from Feature table */
		-- 	Feature.descr AS feature_descr, grade AS feature_grade, Feature.units AS feature_area, Feature.ppu AS feature_ppu, Feature.actual_yr_built AS feature_yr_built, deprec_val AS feature_depreciated_val
			CASE WHEN descr LIKE 'Boat%' THEN 1
				ELSE NULL END AS boat_cv,
			CASE WHEN descr LIKE 'Boat%' THEN grade
				ELSE NULL END AS boatcv_grade,
			CASE WHEN descr LIKE 'Boat%' THEN Feature.units
				ELSE NULL END AS boatcv_area,
			CASE WHEN descr LIKE 'Boat%' THEN Feature.ppu
				ELSE NULL END AS boatcv_ppu,
			CASE WHEN descr LIKE 'Boat%' THEN Feature.actual_yr_built
				ELSE NULL END AS boatcv_yr_built,
			CASE WHEN descr LIKE 'Boat%' THEN deprec_val 
				ELSE NULL END AS boatcv_depreciated_value,
			CASE WHEN descr LIKE 'Carp%' THEN 1
				ELSE NULL END AS carport_ft,
			CASE WHEN descr LIKE 'Carp%' THEN grade
				ELSE NULL END AS carportft_grade,
			CASE WHEN descr LIKE 'Carp%' THEN Feature.units
				ELSE NULL END AS carportft_area,
			CASE WHEN descr LIKE 'Carp%' THEN Feature.ppu
				ELSE NULL END AS carportft_ppu,
			CASE WHEN descr LIKE 'Carp%' THEN Feature.actual_yr_built
				ELSE NULL END AS carportft_yr_built,
			CASE WHEN descr LIKE 'Carp%' THEN deprec_val 
				ELSE NULL END AS carportft_depreciated_value,
			CASE WHEN descr LIKE 'Carp%' THEN substr(descr,-2,2)
				ELSE NULL END AS carportft_material,
			CASE WHEN descr LIKE 'Cov P%' THEN 1
				ELSE NULL END AS cov_patio,
			CASE WHEN descr LIKE 'Cov P%' THEN grade
				ELSE NULL END AS covpatio_grade,
			CASE WHEN descr LIKE 'Cov P%' THEN Feature.units
				ELSE NULL END AS covpatio_area,
			CASE WHEN descr LIKE 'Cov P%' THEN Feature.ppu
				ELSE NULL END AS covpatio_ppu,
			CASE WHEN descr LIKE 'Cov P%' THEN Feature.actual_yr_built
				ELSE NULL END AS covpatio_yr_built,
			CASE WHEN descr LIKE 'Cov P%' THEN deprec_val 
				ELSE NULL END AS covpatio_depreciated_value,
	-- 		CASE WHEN descr LIKE 'Ctl%' THEN 1
	-- 			ELSE 0 END AS cattle_shed,
	-- 		CASE WHEN descr LIKE 'Ctl%' THEN grade
	-- 			ELSE 0 END AS cattleshed_grade,
	-- 		CASE WHEN descr LIKE 'Ctl%' THEN Feature.units
	-- 			ELSE 0 END AS cattleshed_area,
	-- 		CASE WHEN descr LIKE 'Ctl%' THEN Feature.ppu
	-- 			ELSE 0 END AS cattleshed_ppu,
	-- 		CASE WHEN descr LIKE 'Ctl%' THEN Feature.actual_yr_built
	-- 			ELSE 0 END AS cattleshed_yr_built,
	-- 		CASE WHEN descr LIKE 'Ctl%' THEN deprec_val 
	-- 			ELSE 0 END AS cattleshed_depreciated_value,
	-- 		CASE WHEN descr LIKE 'Dairy%' THEN 1
	-- 			ELSE 0 END AS dairy,
	-- 		CASE WHEN descr LIKE 'Dairy%' THEN grade
	-- 			ELSE 0 END AS dairy_grade,
	-- 		CASE WHEN descr LIKE 'Dairy%' THEN Feature.units
	-- 			ELSE 0 END AS dairy_area,
	-- 		CASE WHEN descr LIKE 'Dairy%' THEN Feature.ppu
	-- 			ELSE 0 END AS dairy_ppu,
	-- 		CASE WHEN descr LIKE 'Dairy%' THEN Feature.actual_yr_built
	-- 			ELSE 0 END AS dairy_yr_built,
	-- 		CASE WHEN descr LIKE 'Dairy%' THEN deprec_val 
	-- 			ELSE 0 END AS dairy_depreciated_value,
			CASE WHEN descr LIKE 'Deck%' THEN 1
				ELSE NULL END AS deck_ft,
			CASE WHEN descr LIKE 'Deck%' THEN grade
				ELSE NULL END AS deckft_grade,
			CASE WHEN descr LIKE 'Deck%' THEN Feature.units
				ELSE NULL END AS deckft_area,
			CASE WHEN descr LIKE 'Deck%' THEN Feature.ppu
				ELSE NULL END AS deckft_ppu,
			CASE WHEN descr LIKE 'Deck%' THEN Feature.actual_yr_built
				ELSE NULL END AS deckft_yr_built,
			CASE WHEN descr LIKE 'Deck%' THEN deprec_val 
				ELSE NULL END AS deckft_depreciated_value,
			CASE WHEN descr LIKE 'Dock%' THEN 1
				ELSE NULL END AS dock,
			CASE WHEN descr LIKE 'Dock%' THEN grade
				ELSE NULL END AS dock_grade,
			CASE WHEN descr LIKE 'Dock%' THEN Feature.units
				ELSE NULL END AS dock_area,
			CASE WHEN descr LIKE 'Dock%' THEN Feature.ppu
				ELSE NULL END AS dock_ppu,
			CASE WHEN descr LIKE 'Dock%' THEN Feature.actual_yr_built
				ELSE NULL END AS dock_yr_built,
			CASE WHEN descr LIKE 'Dock%' THEN deprec_val 
				ELSE NULL END AS dock_depreciated_value,
			CASE WHEN descr LIKE 'Elevator%' THEN 1
				ELSE NULL END AS elevator,
			CASE WHEN descr LIKE 'Elevator%' THEN grade
				ELSE NULL END AS elevator_grade,
			CASE WHEN descr LIKE 'Elevator%' THEN Feature.units
				ELSE NULL END AS elevator_area,
			CASE WHEN descr LIKE 'Elevator%' THEN Feature.ppu
				ELSE NULL END AS elevator_ppu,
			CASE WHEN descr LIKE 'Elevator%' THEN Feature.actual_yr_built
				ELSE NULL END AS elevator_yr_built,
			CASE WHEN descr LIKE 'Elevator%' THEN deprec_val 
				ELSE NULL END AS elevator_depreciated_value,
			CASE WHEN descr LIKE 'Fence%' THEN 1
				ELSE NULL END AS fence,
			CASE WHEN descr LIKE 'Fence%' THEN grade
				ELSE NULL END AS fence_grade,
			CASE WHEN descr LIKE 'Fence%' THEN Feature.units
				ELSE NULL END AS fence_area,
			CASE WHEN descr LIKE 'Fence%' THEN Feature.ppu
				ELSE NULL END AS fence_ppu,
			CASE WHEN descr LIKE 'Fence%' THEN Feature.actual_yr_built
				ELSE NULL END AS fence_yr_built,
			CASE WHEN descr LIKE 'Fence%' THEN deprec_val 
				ELSE NULL END AS fence_depreciated_value,
	-- 		CASE WHEN descr LIKE 'Fence%' THEN substr(descr,-4,4)
	-- 			ELSE '' END AS fence_material,
			CASE WHEN descr LIKE 'Firep%' THEN 1
				ELSE NULL END AS fireplace,
			CASE WHEN descr LIKE 'Firep%' THEN grade
				ELSE NULL END AS fireplace_grade,
			CASE WHEN descr LIKE 'Firep%' THEN Feature.units
				ELSE NULL END AS fireplace_area,
			CASE WHEN descr LIKE 'Firep%' THEN Feature.ppu
				ELSE NULL END AS fireplace_ppu,
			CASE WHEN descr LIKE 'Firep%' THEN Feature.actual_yr_built
				ELSE NULL END AS fireplace_yr_built,
			CASE WHEN descr LIKE 'Firep%' THEN deprec_val 
				ELSE NULL END AS fireplace_depreciated_value,
			CASE WHEN descr LIKE 'Gaz%' THEN 1
				ELSE NULL END AS gazebo,
			CASE WHEN descr LIKE 'Gaz%' THEN grade
				ELSE NULL END AS gazebo_grade,
			CASE WHEN descr LIKE 'Gaz%' THEN Feature.units
				ELSE NULL END AS gazebo_area,
			CASE WHEN descr LIKE 'Gaz%' THEN Feature.ppu
				ELSE NULL END AS gazebo_ppu,
			CASE WHEN descr LIKE 'Gaz%' THEN Feature.actual_yr_built
				ELSE NULL END AS gazebo_yr_built,
			CASE WHEN descr LIKE 'Gaz%' THEN deprec_val 
				ELSE NULL END AS gazebo_depreciated_value,
			CASE WHEN descr LIKE 'Grnh%' THEN 1
				ELSE NULL END AS greenhouse,
			CASE WHEN descr LIKE 'Grnh%' THEN grade
				ELSE NULL END AS greenhouse_grade,
			CASE WHEN descr LIKE 'Grnh%' THEN Feature.units
				ELSE NULL END AS greenhouse_area,
			CASE WHEN descr LIKE 'Grnh%' THEN Feature.ppu
				ELSE NULL END AS greenhouse_ppu,
			CASE WHEN descr LIKE 'Grnh%' THEN Feature.actual_yr_built
				ELSE NULL END AS greenhouse_yr_built,
			CASE WHEN descr LIKE 'Grnh%' THEN deprec_val 
				ELSE NULL END AS greenhouse_depreciated_value,
			CASE WHEN descr LIKE 'Plty%' THEN 1
				ELSE NULL END AS coop,
			CASE WHEN descr LIKE 'Plty%' THEN grade
				ELSE NULL END AS coop_grade,
			CASE WHEN descr LIKE 'Plty%' THEN Feature.units
				ELSE NULL END AS coop_area,
			CASE WHEN descr LIKE 'Plty%' THEN Feature.ppu
				ELSE NULL END AS coop_ppu,
			CASE WHEN descr LIKE 'Plty%' THEN Feature.actual_yr_built
				ELSE NULL END AS coop_yr_built,
			CASE WHEN descr LIKE 'Plty%' THEN deprec_val 
				ELSE NULL END AS coop_depreciated_value,
			CASE WHEN descr LIKE 'Pool%' THEN 1
				ELSE NULL END AS pool,
			CASE WHEN descr LIKE 'Pool%' THEN grade
				ELSE NULL END AS pool_grade,
			CASE WHEN descr LIKE 'Pool%' THEN Feature.units
				ELSE NULL END AS pool_area,
			CASE WHEN descr LIKE 'Pool%' THEN Feature.ppu
				ELSE NULL END AS pool_ppu,
			CASE WHEN descr LIKE 'Pool%' THEN Feature.actual_yr_built
				ELSE NULL END AS pool_yr_built,
			CASE WHEN descr LIKE 'Pool%' THEN deprec_val 
				ELSE NULL END AS pool_depreciated_value,
			CASE WHEN descr LIKE 'Rball%' THEN 1
				ELSE NULL END AS rball_court,
			CASE WHEN descr LIKE 'Rball%' THEN grade
				ELSE NULL END AS rball_grade,
			CASE WHEN descr LIKE 'Rball%' THEN Feature.units
				ELSE NULL END AS rball_area,
			CASE WHEN descr LIKE 'Rball%' THEN Feature.ppu
				ELSE NULL END AS rball_ppu,
			CASE WHEN descr LIKE 'Rball%' THEN Feature.actual_yr_built
				ELSE NULL END AS rball_yr_built,
			CASE WHEN descr LIKE 'Rball%' THEN deprec_val 
				ELSE NULL END AS rball_depreciated_value,
			CASE WHEN descr LIKE 'Sauna' THEN 1
				ELSE NULL END AS sauna,
			CASE WHEN descr LIKE 'Sauna' THEN grade
				ELSE NULL END AS sauna_grade,
			CASE WHEN descr LIKE 'Sauna' THEN Feature.units
				ELSE NULL END AS sauna_area,
			CASE WHEN descr LIKE 'Sauna' THEN Feature.ppu
				ELSE NULL END AS sauna_ppu,
			CASE WHEN descr LIKE 'Sauna' THEN Feature.actual_yr_built
				ELSE NULL END AS sauna_yr_built,
			CASE WHEN descr LIKE 'Sauna' THEN deprec_val 
				ELSE NULL END AS sauna_depreciated_value,
			CASE WHEN descr LIKE 'Shed%' THEN 1
				ELSE NULL END AS shed,
			CASE WHEN descr LIKE 'Shed%' THEN grade
				ELSE NULL END AS shed_grade,
			CASE WHEN descr LIKE 'Shed%' THEN Feature.units
				ELSE NULL END AS shed_area,
			CASE WHEN descr LIKE 'Shed%' THEN Feature.ppu
				ELSE NULL END AS shed_ppu,
			CASE WHEN descr LIKE 'Shed%' THEN Feature.actual_yr_built
				ELSE NULL END AS shed_yr_built,
			CASE WHEN descr LIKE 'Shed%' THEN deprec_val 
				ELSE NULL END AS shed_depreciated_value,
	-- 		CASE WHEN descr LIKE 'Shed%' THEN substr(descr,-4,4)
	-- 			ELSE '' END AS shed_material,
			CASE WHEN descr LIKE 'Spa' THEN 1
				ELSE NULL END AS spa,
			CASE WHEN descr LIKE 'Spa' THEN grade
				ELSE NULL END AS spa_grade,
			CASE WHEN descr LIKE 'Spa' THEN Feature.units
				ELSE NULL END AS spa_area,
			CASE WHEN descr LIKE 'Spa' THEN Feature.ppu
				ELSE NULL END AS spa_ppu,
			CASE WHEN descr LIKE 'Spa' THEN Feature.actual_yr_built
				ELSE NULL END AS spa_yr_built,
			CASE WHEN descr LIKE 'Spa' THEN deprec_val 
				ELSE NULL END AS spa_depreciated_value,
			CASE WHEN descr LIKE 'Stable%' THEN 1
				ELSE NULL END AS stable,
			CASE WHEN descr LIKE 'Stable%' THEN grade
				ELSE NULL END AS stable_grade,
			CASE WHEN descr LIKE 'Stable%' THEN Feature.units
				ELSE NULL END AS stable_area,
			CASE WHEN descr LIKE 'Stable%' THEN Feature.ppu
				ELSE NULL END AS stable_ppu,
			CASE WHEN descr LIKE 'Stable%' THEN Feature.actual_yr_built
				ELSE NULL END AS stable_yr_built,
			CASE WHEN descr LIKE 'Stable%' THEN deprec_val 
				ELSE NULL END AS stable_depreciated_value,
			CASE WHEN descr LIKE 'Sun R%' THEN 1
				ELSE NULL END AS sun_rm,
			CASE WHEN descr LIKE 'Sun R%' THEN grade
				ELSE NULL END AS sunrm_grade,
			CASE WHEN descr LIKE 'Sun R%' THEN Feature.units
				ELSE NULL END AS sunrm_area,
			CASE WHEN descr LIKE 'Sun R%' THEN Feature.ppu
				ELSE NULL END AS sunrm_ppu,
			CASE WHEN descr LIKE 'Sun R%' THEN Feature.actual_yr_built
				ELSE NULL END AS sunrm_yr_built,
			CASE WHEN descr LIKE 'Sun R%' THEN deprec_val 
				ELSE NULL END AS sunrm_depreciated_value,
			CASE WHEN descr LIKE 'Tennis%' THEN 1
				ELSE NULL END AS tennis_ct,
			CASE WHEN descr LIKE 'Tennis%' THEN grade
				ELSE NULL END AS tennis_grade,
			CASE WHEN descr LIKE 'Tennis%' THEN Feature.units
				ELSE NULL END AS tennis_area,
			CASE WHEN descr LIKE 'Tennis%' THEN Feature.ppu
				ELSE NULL END AS tennis_ppu,
			CASE WHEN descr LIKE 'Tennis%' THEN Feature.actual_yr_built
				ELSE NULL END AS tennis_yr_built,
			CASE WHEN descr LIKE 'Tennis%' THEN deprec_val 
				ELSE NULL END AS tennis_depreciated_value,
			CASE WHEN (descr LIKE 'Can D%' OR descr LIKE 'Elev St%' OR descr LIKE 'Equip%' OR descr LIKE'F/P%' OR descr LIKE 'GP Barn%' OR descr LIKE 'Gar/%' OR descr LIKE 'Grg/%' OR descr LIKE 'Hay%' OR descr LIKE 'Light%' OR descr LIKE 'Lt Pole%' OR descr LIKE 'Pav %' OR descr LIKE 'Res E%' OR descr LIKE 'Scr%' OR descr LIKE 'Sprink%' OR descr LIKE 'Tool%' OR descr LIKE 'Utility%') THEN 1
				ELSE 0 END AS other_fts
			FROM 
				(
				SELECT 
				/* Restated Parcel table columns */
				RE, mailing_1, mailing_2, mailing_city, mailing_state, property_use, subdivision, neighborhood, property_value, county_taxable, total_sf, acres,
				/* Columns from Building table */
				bldng_num, type_descr, style, class, quality, yr_built, perc_complete, bldng_value, heated_sf,
				/* Restated Sale table columns */
				trans_id, seller, sale_date, price
				FROM
					(SELECT 
						/* Restated Parcel table columns */
						RE, mailing_1, mailing_2, mailing_city, mailing_state, property_use, subdivision, neighborhood, property_value, county_taxable, total_sf, acres,
						/* Columns from Sale table */
						(or_book || '-' || or_page) AS trans_id, seller, sale_date, SUM(DISTINCT(price)) AS price
					FROM 
						(
						SELECT 
						/* Columns from Parcel table */
						Parcel.RE, mailing_1, mailing_2, mailing_city, mailing_state, property_use, subdivision, neighborhood, just_val AS property_value, county_taxable, square_feet AS total_sf, acres
						FROM 
							Parcel
						WHERE
							(property_use = 0 OR property_use = 100 OR property_use = 200 OR property_use = 700 OR property_use = 9999)
						) AS parcels_query
					LEFT JOIN Sale
					USING (RE)
					WHERE 
						/* Filter Sale table to remove deed transfers and sales of vacant land */
						improved = 'I' AND price > 1000
					GROUP BY RE, sale_date) AS sales_query
				LEFT JOIN
					(
					SELECT 
						RE, 
						/* Columns from Building table */
						Building.building AS bldng_num, type_descr, style, class, quality, Building.actual_yr_built AS yr_built, perc_complete, value AS bldng_value, heated_sf
					FROM 
						(
						SELECT 
						/* Columns from Parcel table */
						Parcel.RE, mailing_1, mailing_2, mailing_city, mailing_state, property_use, subdivision, neighborhood, just_val AS property_value, county_taxable, square_feet AS total_sf, acres
						FROM 
							Parcel
						WHERE
							(property_use = 0 OR property_use = 100 OR property_use = 200 OR property_use = 700 OR property_use = 9999)
						)
					LEFT JOIN Building
					USING (RE)
					WHERE 
						Building.building NOT NULL AND (type_descr LIKE 'SFR%' OR type_descr LIKE 'MH %' OR type_descr = 'TOWNHOUSE' OR type_descr = 'CONVERTED RESIDENCE')
					)
				USING (RE)
			)
		LEFT JOIN Feature
		USING (RE)
		WHERE descr NOT NULL
		)
	GROUP BY RE, building
	) AS features_fixed
USING (RE, building)
LEFT JOIN 
		(
		SELECT  RE, building, sub_structure_descr, 
		SUM(addition) AS additions,
		SUM(DISTINCT(addition_area)) AS addition_area,
		SUM(DISTINCT(addition_effec)) AS addition_effec,
		SUM(DISTINCT(addition_heated)) AS addition_heated,
		SUM(balcony) AS balconies,
		SUM(DISTINCT(balcony_area)) AS balcony_area,
		SUM(DISTINCT(balcony_effec)) AS balcony_effec,
		SUM(DISTINCT(balcony_heated)) AS balcony_heated,
		basement,
		basement_area,
		basement_effec,
		basement_unfinished,
		SUM(canopy) AS canopies,
		SUM(DISTINCT(canopy_area)) AS canopy_area,
		SUM(DISTINCT(canopy_effec)) AS canopy_effec,
		SUM(DISTINCT(canopy_heated)) AS canopy_heated,
		SUM(cabana) AS cabanas, 
		SUM(DISTINCT(cabana_area)) AS cabana_area,
		SUM(DISTINCT(cabana_effec)) AS cabana_effec,
		SUM(DISTINCT(cabana_heated)) AS cabana_heated,
		SUM(carport) AS carports,
		SUM(DISTINCT(carport_area)) AS carport_area,
		SUM(DISTINCT(carport_effec)) AS carport_effec,
		SUM(DISTINCT(carport_heated)) AS carport_heated,
		SUM(carport_detached) AS carport_detached,
		SUM(carport_unfinished) AS carport_unfinished,
		SUM(deck) AS decks,
		SUM(DISTINCT(deck_area)) AS deck_area,
		SUM(DISTINCT(deck_effec)) AS deck_effec,
		SUM(DISTINCT(deck_heated)) AS deck_heated,
		SUM(det_utility) AS det_utility,
		SUM(DISTINCT(det_utility_area)) AS det_utility_area,
		SUM(DISTINCT(det_utility_effec)) AS det_utility_effec,
		SUM(DISTINCT(det_utility_heated)) AS det_utility_heated,
		SUM(det_utility_unfinished) AS det_utility_unfinished,
		SUM(dormer) AS dormers,
		SUM(dormer_area) AS dormer_area,
		SUM(dormer_effec) AS dormer_effec,
		SUM(dormer_heated) AS dormer_heated,
		entry_corr,
		entry_area,
		entry_effec,
		entry_heated,
		finished_attic,
		attic_area,
		attic_effec,
		attic_heated,
		SUM(garage) AS garages,
		SUM(DISTINCT(garage_area)) AS garage_area,
		SUM(DISTINCT(garage_effec)) AS garage_effec,
		SUM(DISTINCT(garage_heated)) AS garage_heated,
		SUM(garage_detached) AS garage_detached,
		SUM(garage_unfinished) AS garage_unfinished,
		SUM(patio) AS patios,
		SUM(DISTINCT(patio_area)) AS patio_area,
		SUM(DISTINCT(patio_effec)) AS patio_effec,
		SUM(DISTINCT(patio_heated)) AS patio_heated,
		SUM(porch) AS porches,
		SUM(DISTINCT(porch_area)) AS porch_area,
		SUM(DISTINCT(porch_effec)) AS porch_effec,
		SUM(DISTINCT(porch_heated)) AS porch_heated,
		SUM(porch_screened) AS porch_screened,
		SUM(porch_detached) AS porch_detached,
		SUM(porch_enclosed) AS porch_enclosed,
		SUM(porch_unfinished) AS porch_unfinished,
		SUM(stoop) AS stoops,
		SUM(stoop_area) AS stoop_area,
		SUM(stoop_effec) AS stoop_effec,
		SUM(stoop_heated) AS stoop_heated,
		SUM(storage) AS storages,
		SUM(DISTINCT(storage_area)) AS storage_area,
		SUM(DISTINCT(storage_effec)) AS storage_effec,
		SUM(DISTINCT(storage_heated)) AS storage_heated,
		SUM(storage_unfinished) AS storage_unfinished,
		SUM(upper_story) AS upper_stories,
		SUM(upper_story_area) AS upper_story_area, 
		SUM(upper_story_effec) AS upper_story_effec,
		SUM(upper_story_heated) AS upper_story_heated,
		SUM(upper_story_unfinished) AS upper_story_unfinished
		FROM 
				(
				SELECT  RE,
						building,
						sub_structure_descr,
						CASE WHEN sub_structure_descr = 'Addition' THEN 1
							ELSE 0 END AS addition,
						CASE WHEN sub_structure_descr = 'Addition' THEN actual_area
							ELSE 0 END AS addition_area,
						CASE WHEN sub_structure_descr = 'Addition' THEN effec_area
							ELSE 0 END AS addition_effec,
						CASE WHEN sub_structure_descr = 'Addition' THEN heated_area
							ELSE 0 END AS addition_heated,
						CASE WHEN sub_structure_descr = 'Balcony' THEN 1
							ELSE 0 END AS balcony,
						CASE WHEN sub_structure_descr = 'Balcony' THEN actual_area
							ELSE 0 END AS balcony_area,
						CASE WHEN sub_structure_descr = 'Balcony' THEN effec_area
							ELSE 0 END AS balcony_effec,
						CASE WHEN sub_structure_descr = 'Balcony' THEN heated_area
							ELSE 0 END AS balcony_heated,
						CASE WHEN (sub_structure_descr LIKE '%Basement') OR (sub_structure_descr LIKE '%Base') THEN 1
							ELSE 0 END AS basement,
						CASE WHEN (sub_structure_descr LIKE '%Basement') OR (sub_structure_descr LIKE '%Base') THEN actual_area
							ELSE 0 END AS basement_area,
						CASE WHEN (sub_structure_descr LIKE '%Basement') OR (sub_structure_descr LIKE '%Base') THEN effec_area
							ELSE 0 END AS basement_effec,
						CASE WHEN (sub_structure_descr LIKE '%Basement') OR (sub_structure_descr LIKE '%Base') THEN heated_area
							ELSE 0 END AS basement_heated,
						CASE WHEN ((sub_structure_descr LIKE '%Basement') OR (sub_structure_descr LIKE '%Base')) AND sub_structure_descr LIKE '%Unf%'  THEN 1
							ELSE 0 END AS basement_unfinished,
						CASE WHEN sub_structure_descr LIKE '%Cabana' THEN 1
							ELSE 0 END AS cabana,
						CASE WHEN sub_structure_descr LIKE '%Cabana' THEN actual_area
							ELSE 0 END AS cabana_area,
						CASE WHEN sub_structure_descr LIKE '%Cabana' THEN effec_area
							ELSE 0 END AS cabana_effec,
						CASE WHEN sub_structure_descr LIKE '%Cabana' THEN heated_area
							ELSE 0 END AS cabana_heated,
						CASE WHEN sub_structure_descr = 'Canopy' THEN 1
							ELSE 0 END AS canopy,
						CASE WHEN sub_structure_descr = 'Canopy' THEN actual_area
							ELSE 0 END AS canopy_area,
						CASE WHEN sub_structure_descr = 'Canopy' THEN effec_area
							ELSE 0 END AS canopy_effec,
						CASE WHEN sub_structure_descr = 'Canopy' THEN heated_area
							ELSE 0 END AS canopy_heated,
						CASE WHEN sub_structure_descr LIKE '%Carport' THEN 1
							ELSE 0 END AS carport,
						CASE WHEN sub_structure_descr LIKE '%Carport' THEN actual_area
							ELSE 0 END AS carport_area,
						CASE WHEN sub_structure_descr LIKE '%Carport' THEN effec_area
							ELSE 0 END AS carport_effec,
						CASE WHEN sub_structure_descr LIKE '%Carport' THEN heated_area
							ELSE 0 END AS carport_heated,
						CASE WHEN (sub_structure_descr LIKE '%Carport') AND (sub_structure_descr LIKE '%Det%') THEN 1
							ELSE 0 END AS carport_detached,
						CASE WHEN (sub_structure_descr LIKE '%Carport') AND (sub_structure_descr LIKE '%Unf%') THEN 1
							ELSE 0 END AS carport_unfinished,
						CASE WHEN sub_structure_descr = 'Deck' THEN 1
							ELSE 0 END AS deck,
						CASE WHEN sub_structure_descr = 'Deck' THEN actual_area
							ELSE 0 END AS deck_area,
						CASE WHEN sub_structure_descr = 'Deck' THEN effec_area
							ELSE 0 END AS deck_effec,
						CASE WHEN sub_structure_descr = 'Deck' THEN heated_area
							ELSE 0 END AS deck_heated,
						CASE WHEN sub_structure_descr = 'Dormer' THEN 1
							ELSE 0 END AS dormer,
						CASE WHEN sub_structure_descr = 'Dormer' THEN actual_area
							ELSE 0 END AS dormer_area,
						CASE WHEN sub_structure_descr = 'Dormer' THEN effec_area
							ELSE 0 END AS dormer_effec,
						CASE WHEN sub_structure_descr = 'Dormer' THEN heated_area
							ELSE 0 END AS dormer_heated,
						CASE WHEN sub_structure_descr = 'Common Entry Corridor' THEN 1
							ELSE 0 END AS entry_corr,
						CASE WHEN sub_structure_descr = 'Common Entry Corridor' THEN actual_area
							ELSE 0 END AS entry_area,
						CASE WHEN sub_structure_descr = 'Common Entry Corridor' THEN effec_area
							ELSE 0 END AS entry_effec,
						CASE WHEN sub_structure_descr = 'Common Entry Corridor' THEN heated_area
							ELSE 0 END AS entry_heated,
						CASE WHEN sub_structure_descr = 'Finished Attic' THEN 1
							ELSE 0 END AS finished_attic,
						CASE WHEN sub_structure_descr = 'Finished Attic' THEN actual_area
							ELSE 0 END AS attic_area,
						CASE WHEN sub_structure_descr = 'Finished Attic' THEN effec_area
							ELSE 0 END AS attic_effec,
						CASE WHEN sub_structure_descr = 'Finished Attic' THEN heated_area
							ELSE 0 END AS attic_heated,
						CASE WHEN sub_structure_descr LIKE '%Garage' THEN 1
							ELSE 0 END AS garage,
						CASE WHEN sub_structure_descr LIKE '%Garage' THEN actual_area
							ELSE 0 END AS garage_area,
						CASE WHEN sub_structure_descr LIKE '%Garage' THEN effec_area
							ELSE 0 END AS garage_effec,
						CASE WHEN sub_structure_descr LIKE '%Garage' THEN heated_area
							ELSE 0 END AS garage_heated,
						CASE WHEN (sub_structure_descr LIKE '%Garage') AND (sub_structure_descr LIKE '%Det%') THEN 1
							ELSE 0 END AS garage_detached,
						CASE WHEN (sub_structure_descr LIKE '%Garage') AND (sub_structure_descr LIKE '%Unf%') THEN 1
							ELSE 0 END AS garage_unfinished,
						CASE WHEN sub_structure_descr = 'Patio' THEN 1
							ELSE 0 END AS patio,
						CASE WHEN sub_structure_descr = 'Patio' THEN actual_area
							ELSE 0 END AS patio_area,
						CASE WHEN sub_structure_descr = 'Patio' THEN effec_area
							ELSE 0 END AS patio_effec,
						CASE WHEN sub_structure_descr = 'Patio' THEN heated_area
							ELSE 0 END AS patio_heated,
						CASE WHEN sub_structure_descr LIKE '%Porch' THEN 1
							ELSE 0 END AS porch,
						CASE WHEN sub_structure_descr LIKE '%Porch' THEN actual_area
							ELSE 0 END AS porch_area,
						CASE WHEN sub_structure_descr LIKE '%Porch' THEN effec_area
							ELSE 0 END AS porch_effec,
						CASE WHEN sub_structure_descr LIKE '%Porch' THEN heated_area
							ELSE 0 END AS porch_heated,
						CASE WHEN (sub_structure_descr LIKE '%Porch') AND (sub_structure_descr LIKE '%sc%') THEN 1
							ELSE 0 END AS porch_screened,
						CASE WHEN (sub_structure_descr LIKE '%Porch') AND (sub_structure_descr LIKE '%Det%') THEN 1
							ELSE 0 END AS porch_detached,
						CASE WHEN (sub_structure_descr LIKE '%Porch') AND (sub_structure_descr LIKE '%Encl') THEN 1
							ELSE 0 END AS porch_enclosed,
						CASE WHEN (sub_structure_descr LIKE '%Porch') AND (sub_structure_descr LIKE '%Unf%') THEN 1
							ELSE 0 END AS porch_unfinished,
						CASE WHEN sub_structure_descr = 'Stoop' THEN 1
							ELSE 0 END AS stoop,
						CASE WHEN sub_structure_descr = 'Stoop' THEN actual_area
							ELSE 0 END AS stoop_area,
						CASE WHEN sub_structure_descr = 'Stoop' THEN effec_area
							ELSE 0 END AS stoop_effec,
						CASE WHEN sub_structure_descr = 'Stoop' THEN heated_area
							ELSE 0 END AS stoop_heated,
						CASE WHEN sub_structure_descr LIKE '%Storage' THEN 1
							ELSE 0 END AS storage,
						CASE WHEN sub_structure_descr LIKE '%Storage' THEN actual_area
							ELSE 0 END AS storage_area,
						CASE WHEN sub_structure_descr LIKE '%Storage' THEN effec_area
							ELSE 0 END AS storage_effec,
						CASE WHEN sub_structure_descr LIKE '%Storage' THEN heated_area
							ELSE 0 END AS storage_heated,
						CASE WHEN (sub_structure_descr LIKE '%Storage') AND (sub_structure_descr LIKE 'Unfin%') THEN 1
							ELSE 0 END AS storage_unfinished,
						CASE WHEN sub_structure_descr LIKE '%upper story%' THEN 1
							ELSE 0 END AS upper_story,
						CASE WHEN sub_structure_descr LIKE '%upper story%' THEN actual_area
							ELSE 0 END AS upper_story_area,
						CASE WHEN sub_structure_descr LIKE '%upper story%' THEN effec_area
							ELSE 0 END AS upper_story_effec,
						CASE WHEN sub_structure_descr LIKE '%upper story%' THEN heated_area
							ELSE 0 END AS upper_story_heated,
						CASE WHEN sub_structure_descr = 'Unfin Upper Story'  THEN 1
							ELSE 0 END AS upper_story_unfinished,
						CASE WHEN sub_structure_descr LIKE '%Utility' THEN 1
							ELSE 0 END AS det_utility,
						CASE WHEN sub_structure_descr LIKE '%Utility' THEN actual_area
							ELSE 0 END AS det_utility_area,
						CASE WHEN sub_structure_descr LIKE '%Utility' THEN effec_area
							ELSE 0 END AS det_utility_effec,
						CASE WHEN sub_structure_descr LIKE '%Utility' THEN heated_area
							ELSE 0 END AS det_utility_heated,
						CASE WHEN (sub_structure_descr LIKE '%Utility') AND (sub_structure_descr LIKE 'Unfin%') THEN 1
							ELSE 0 END AS det_utility_unfinished		
						FROM Parcel
						LEFT JOIN Subarea
						USING (RE)
						WHERE (property_use = 0 OR property_use = 100 OR property_use = 200 OR property_use = 700 OR property_use = 9999)
								AND sub_structure_descr <> 'Base Area' AND sub_structure_descr <> 'Adds Additional Area' AND sub_structure_descr NOT LIKE '%Office%'
						) AS subarea_cols
						GROUP BY RE, building
				) AS subarea_totals
USING (RE, building)