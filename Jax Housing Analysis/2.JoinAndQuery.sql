/* Final query (filter in bottom WHERE clause) */
SELECT *
FROM
(
SELECT  
		(SUBSTR(RE,1,6)||' '||SUBSTR(RE,7,4)) AS RE,
		/* Owner table query */
		owner_1, owner_2, owner_3,
		/* Parcel table query */
		CASE WHEN mailing_2 NOT NULL THEN (TRIM(mailing_1)||' '||TRIM(mailing_2)) 
			ELSE TRIM(mailing_1) END AS mailing_address,
		/* Two properties in the database did not list mailing_city. In both cases, the owner resides in Jacksonville. */
		CASE WHEN mailing_city NOT NULL THEN TRIM(mailing_city)
			ELSE 'JACKSONVILLE' END AS mailing_city, 
		IFNULL(mailing_state, 'FOREIGN COUNTRY') mailing_state, property_use, 
		IFNULL(subdivision, 'NOT LISTED') subdivision, neighborhood, val_method, 
		CASE WHEN cap_base_yr = 1 THEN 0
			ELSE cap_base_yr END AS cap_base_yr, 
		market_val, assessed_val, building_val, just_val, school_taxable, county_taxable, sjrwnd_taxable, 
		taxing_district, square_feet,
		/* Characteristic table query */
		char_descr,
		canal,
		golf,
		intracoastal,
		lake,
		misc_waterway,
		ocean_front,
		ortega_river,
		ribault_river,
		stjohns_river,
		trout_river,
		/* Building table query */
		IFNULL(building, 0) AS building, IFNULL(type_descr, 'VACANT') AS type_descr, style, 
		class, quality, IFNULL(actual_yr_built,0) AS actual_yr_built,
		IFNULL(effec_yr_built,0) AS effec_yr_built, IFNULL(perc_complete,0.0) AS perc_complete, 
		IFNULL(value,0) AS value, IFNULL(heated_sf,0) AS heated_sf,
		/* Utility table query */
		stories, bedrooms, baths, rooms, 
		/* Common table query */
		max_units_per_acre,
		use_canal,
		use_golf,
		use_marsh,
		use_ocean,
		use_pond,
		use_river,
		land_val,
		use_types,
		/* Sales table query */
		trans_id, status, reason, sale_date, seller_1, seller_2, improved, IFNULL(price,0) AS price,
		/* Feature table query */
		boat_cv, boatcv_ppu, boatcv_yr, 
		carport, carport_ppu, carport_yr,
		cov_patio, covpatio_ppu, covpatio_yr,
		deck, deck_ppu, deck_yr, 
		dock, dock_ppu, dock_yr,
		fireplace, fireplace_ppu, fireplace_yr,
		pool, pool_ppu, pool_yr,
		scr_porch, scrporch_ppu, scrporch_yr,
		screen_encl, screenencl_ppu, screenencl_yr,
		shed, shed_ppu, shed_yr,
		sun_rm, sunrm_ppu, sunrm_yr,
		/* Subarea table query */
		additions, additions_effec_area,
		balcony_effec_area,
		garage_effec_area,
		fin_storage_effec_area,
		unfin_storage_effec_area
FROM Parcel
LEFT JOIN
(SELECT RE,
		MAX(CASE WHEN line = 1 THEN TRIM(owner)
			ELSE NULL END) AS owner_1,
		MAX(CASE WHEN line = 2 THEN TRIM(owner)
			ELSE NULL END) AS owner_2,
		MAX(CASE WHEN line = 3 THEN TRIM(owner)
			ELSE NULL END) AS owner_3
FROM Owner
GROUP BY RE)
USING (RE)
/* Building table query */
LEFT JOIN 
(SELECT RE,
		building, type_descr, style, class, IFNULL(quality,'NA') AS quality, 
		actual_yr_built, effec_yr_built, perc_complete, value, heated_sf
FROM Building)
USING (RE)
/* Utility table query */
LEFT JOIN
(SELECT  RE, building,
		SUM(CASE WHEN structure_descr = 'Stories' THEN unit_count
			ELSE NULL END) AS stories,
		SUM(CASE WHEN structure_descr = 'Bedrooms' THEN unit_count
			ELSE NULL END) AS bedrooms,
		SUM(CASE WHEN structure_descr = 'Baths' THEN unit_count
			ELSE NULL END) AS baths,
		SUM(CASE WHEN structure_descr LIKE 'Rooms%Units' THEN unit_count
			ELSE NULL END) AS rooms
-- 		SUM(CASE WHEN structure_descr = 'Restrooms' THEN unit_count
-- 			ELSE NULL END) AS restrooms,
-- 		SUM(CASE WHEN structure_descr = 'Avg Story Height' THEN unit_count
-- 			ELSE NULL END) AS avg_story_height
FROM Utility
GROUP BY RE, building) AS room_query
USING (RE, building)
/* Characteristic table query */
LEFT JOIN
(SELECT  RE,
		MAX(CASE WHEN char_descr = 'ARLINGTON RIVER' THEN char_descr
			 WHEN char_descr LIKE '%Avondale%' THEN 'AVONDALE HISTORIC DISTRICT'
			 WHEN char_descr = 'BIG POTTSBURG CREEK' THEN char_descr
			 WHEN char_descr = 'BROWARD RIVER' THEN char_descr
			 WHEN char_descr = 'Browns Dump' THEN UPPER(char_descr)
			 WHEN char_descr = 'BROWARD RIVER' THEN char_descr
			 WHEN char_descr = 'CEDAR CREEK' THEN char_descr
			 WHEN char_descr LIKE 'DUNN%' THEN char_descr
			 WHEN char_descr = 'DURBIN CREEK' THEN char_descr
			 WHEN char_descr = 'Fifth and Cleveland' THEN UPPER(char_descr)
			 WHEN char_descr = 'JULINGTON CREEK' THEN char_descr
			 WHEN char_descr LIKE 'LEM TURNER%' THEN char_descr
			 WHEN char_descr = 'MONCRIEF CREEK' THEN char_descr
			 WHEN char_descr = 'NEWROSE CREEK' THEN char_descr
			 WHEN char_descr LIKE '%Ortega%' THEN 'ORTEGA HISTORIC DISTRICT'
			 WHEN char_descr = 'SILVERSMITH CREEK' THEN char_descr
			 WHEN char_descr LIKE '%Springfield%' THEN 'SPRINGFIELD HISTORIC DISTRICT'
			 ELSE NULL END) AS 'char_descr',
		MAX(CASE WHEN char_descr = 'CANAL' THEN 1
			 ELSE NULL END) AS canal,
		MAX(CASE WHEN char_descr = 'GOLF COURSE' THEN 1
			 ELSE NULL END) AS golf,
		MAX(CASE WHEN char_descr = 'INTRACOASTAL WATERWAY' THEN 1
			 ELSE NULL END) AS intracoastal,
		MAX(CASE WHEN char_descr = 'LAKE' THEN 1
			 ELSE NULL END) AS lake,
		MAX(CASE WHEN char_descr = 'MISCELLANEOUS WATERWAY' THEN 1
			 ELSE NULL END) AS misc_waterway,
		MAX(CASE WHEN char_descr = 'OCEAN FRONT' THEN 1
			 ELSE NULL END) AS ocean_front,
		MAX(CASE WHEN char_descr = 'ORTEGA RIVER' THEN 1
			 ELSE NULL END) AS ortega_river,
		MAX(CASE WHEN char_descr = 'RIBAULT RIVER' THEN 1
			 ELSE NULL END) AS ribault_river,
		MAX(CASE WHEN char_descr = 'ST JOHNS RIVER' THEN 1
			 ELSE NULL END) AS stjohns_river,
		MAX(CASE WHEN char_descr = 'TROUT RIVER' THEN 1
			 ELSE NULL END) AS trout_river
FROM
(SELECT RE
FROM Parcel
WHERE property_use = 100)
LEFT JOIN Characteristic
USING (RE)
GROUP BY RE) AS proximity_sub
USING (RE) 
/* Common table query */
LEFT JOIN
(SELECT  RE,
		MAX(CASE WHEN use_descr LIKE '%1 UNIT PER 100 A%' THEN 0.01
			 WHEN use_descr LIKE '%1 UNIT PER 40 A%' THEN 0.025
			 WHEN use_descr LIKE '%1 UNIT PER 10 A%' THEN 0.1
			 WHEN use_descr LIKE '%1 UNIT PER 2.5 A%' THEN 0.4
			 WHEN use_descr LIKE '%8-19 UNITS PER A%' THEN 19
			 WHEN use_descr LIKE '%3-7 UNITS PER A%' THEN 7
			 WHEN use_descr LIKE '%2 OR LESS%' THEN 2
			 WHEN use_descr LIKE '%20-60 UNITS PER A%' THEN 60
			 ELSE NULL END) AS max_units_per_acre,
		MAX(CASE WHEN use_descr LIKE '%CANAL%' THEN 1
			 ELSE NULL END) AS use_canal,
		MAX(CASE WHEN use_descr LIKE '%GOLF%' THEN 1
			 ELSE NULL END) AS use_golf,
		MAX(CASE WHEN use_descr LIKE '%MARSH%' THEN 1
			 ELSE NULL END) AS use_marsh,
		MAX(CASE WHEN use_descr LIKE '%OCEAN%' THEN 1
			 ELSE NULL END) AS use_ocean,
		MAX(CASE WHEN use_descr LIKE '%POND%' THEN 1
			 ELSE NULL END) AS use_pond,
		MAX(CASE WHEN use_descr LIKE '%RIVER%' THEN 1
			 ELSE NULL END) AS use_river,
		SUM(land_val) AS land_val,
		COUNT(use_descr) AS use_types
FROM 
(SELECT RE
FROM Parcel
WHERE property_use = 100)
LEFT JOIN Common
USING (RE)
GROUP BY RE) AS land_use_query
USING (RE)
/* Sale table query */
LEFT JOIN
(SELECT RE, trans_id, 
		MAX(CASE WHEN RowNumber = 1 THEN seller
			ELSE NULL END) AS seller_1,
		MAX(CASE WHEN RowNumber = 2 THEN seller
			ELSE NULL END) AS seller_2,
		status, reason, improved, (year||'-'||month||'-'||day) AS sale_date, price
FROM
(SELECT RE, (or_book||'_'||or_page) AS trans_id, 
		ROW_NUMBER() OVER (PARTITION BY (or_book||'_'||or_page),RE) AS RowNumber,
		seller,  qualification,
		status, reason, improved,
		CASE WHEN substr(sale_date,2,1) = '/' THEN ('0'||substr(sale_date,1,1))
				ELSE substr(sale_date,1,2) END AS month,
		CASE WHEN (substr(sale_date,2,1) = '/' AND substr(sale_date,4,1) = '/') THEN ('0'||substr(sale_date,3,1))
			WHEN (substr(sale_date,3,1) = '/' AND substr(sale_date,5,1) = '/') THEN ('0'||substr(sale_date,4,1))
			WHEN (substr(sale_date,3,1) = '/' AND substr(sale_date,6,1) = '/') THEN substr(sale_date,4,2)
			ELSE substr(sale_date,3,2) END AS day,
		CASE WHEN (substr(sale_date,-1,1) = 'M') AND (substr(sale_date,-11,1) = ' ') THEN substr(sale_date,-15,4)
			WHEN (substr(sale_date,-1,1) = 'M') AND (substr(sale_date,-11,1) <> ' ') THEN substr(sale_date,-16,4)
			ELSE substr(sale_date,-4,4) END AS year,
		price
FROM Sale
LEFT JOIN Qualification
ON Sale.qualification = Qualification.q_id)
GROUP BY trans_id, RE) AS sales_query
USING (RE)
/* Feature table subquery */
LEFT JOIN
(SELECT  RE,
		IFNULL(building,0) AS building,
		MAX(CASE WHEN descr LIKE 'Boat%' THEN units
			ELSE NULL END) AS boat_cv,
		MAX(CASE WHEN descr LIKE 'Boat%' THEN ppu
			ELSE NULL END) AS boatcv_ppu,
		MAX(CASE WHEN descr LIKE 'Boat%' THEN actual_yr_built
			ELSE NULL END) AS boatcv_yr,
		MAX(CASE WHEN descr LIKE 'Carport%' THEN units
			ELSE NULL END) AS carport,
		MAX(CASE WHEN descr LIKE 'Carport%' THEN ppu
			ELSE NULL END) AS carport_ppu,
		MAX(CASE WHEN descr LIKE 'Carport%' THEN actual_yr_built
			ELSE NULL END) AS carport_yr,
		MAX(CASE WHEN descr = 'Cov Patio' THEN units
			ELSE NULL END) AS cov_patio,
		MAX(CASE WHEN descr = 'Cov Patio' THEN ppu
			ELSE NULL END) AS covpatio_ppu,
		MAX(CASE WHEN descr = 'Cov Patio' THEN actual_yr_built
			ELSE NULL END) AS covpatio_yr,
		MAX(CASE WHEN descr = 'Deck Wd' THEN units
			ELSE NULL END) AS deck,
		MAX(CASE WHEN descr = 'Deck Wd' THEN ppu
			ELSE NULL END) AS deck_ppu,
		MAX(CASE WHEN descr = 'Deck Wd' THEN actual_yr_built
			ELSE NULL END) AS deck_yr,
		MAX(CASE WHEN descr LIKE 'Dock%' THEN units
			ELSE NULL END) AS dock,
		MAX(CASE WHEN descr LIKE 'Dock%' THEN ppu
			ELSE NULL END) AS dock_ppu,
		MAX(CASE WHEN descr LIKE 'Dock%' THEN actual_yr_built
			ELSE NULL END) AS dock_yr,
		MAX(CASE WHEN descr LIKE 'Firep%' THEN units
			ELSE NULL END) AS fireplace,
		MAX(CASE WHEN descr LIKE 'Firep%' THEN ppu
			ELSE NULL END) AS fireplace_ppu,
		MAX(CASE WHEN descr LIKE 'Firep%' THEN actual_yr_built
			ELSE NULL END) AS fireplace_yr,
		MAX(CASE WHEN descr = 'Pool' THEN units
			ELSE NULL END) AS pool,
		MAX(CASE WHEN descr = 'Pool' THEN ppu
			ELSE NULL END) AS pool_ppu,
		MAX(CASE WHEN descr = 'Pool' THEN actual_yr_built
			ELSE NULL END) AS pool_yr,
		MAX(CASE WHEN descr = 'Scr Porch' THEN units
			ELSE NULL END) AS scr_porch,
		MAX(CASE WHEN descr = 'Scr Porch' THEN ppu
			ELSE NULL END) AS scrporch_ppu,
		MAX(CASE WHEN descr = 'Scr Porch' THEN actual_yr_built
			ELSE NULL END) AS scrporch_yr,
		MAX(CASE WHEN descr LIKE 'Screen%' THEN units
			ELSE NULL END) AS screen_encl,
		MAX(CASE WHEN descr LIKE 'Screen%' THEN ppu
			ELSE NULL END) AS screenencl_ppu,
		MAX(CASE WHEN descr LIKE 'Screen%' THEN actual_yr_built
			ELSE NULL END) AS screenencl_yr,
		MAX(CASE WHEN descr LIKE 'Shed%' THEN units
			ELSE NULL END) AS shed,
		MAX(CASE WHEN descr LIKE 'Shed%' THEN ppu
			ELSE NULL END) AS shed_ppu,
		MAX(CASE WHEN descr LIKE 'Shed%' THEN actual_yr_built
			ELSE NULL END) AS shed_yr,
		MAX(CASE WHEN descr = 'Sun Room' THEN units
			ELSE NULL END) AS sun_rm,
		MAX(CASE WHEN descr = 'Sun Room' THEN ppu
			ELSE NULL END) AS sunrm_ppu,
		MAX(CASE WHEN descr = 'Sun Room' THEN actual_yr_built
			ELSE NULL END) AS sunrm_yr
FROM
(SELECT RE
FROM Parcel
WHERE property_use = 100)
LEFT JOIN Feature
USING (RE)
GROUP BY RE, building) AS feature_subquery
USING (RE, building)
/* Subarea table query */
LEFT JOIN
(SELECT  RE,
		IFNULL(building,0) AS building,
		SUM(CASE WHEN sub_structure_descr = 'Addition' THEN 1
			ELSE NULL END) AS additions,
		SUM(CASE WHEN sub_structure_descr = 'Addition' THEN effec_area
			ELSE NULL END) AS additions_effec_area,
		SUM(CASE WHEN sub_structure_descr = 'Balcony' THEN effec_area
			ELSE NULL END) AS balcony_effec_area,
		SUM(CASE WHEN sub_structure_descr LIKE '%Garage%' THEN effec_area
			ELSE NULL END) AS garage_effec_area,
		SUM(CASE WHEN sub_structure_descr = 'Finished Storage' THEN effec_area
			ELSE NULL END) AS fin_storage_effec_area,
		SUM(CASE WHEN sub_structure_descr = 'Unfinished Storage' THEN effec_area
			ELSE NULL END) AS unfin_storage_effec_area
FROM
(SELECT RE
FROM Parcel
WHERE property_use = 100)
LEFT JOIN Subarea
USING (RE)
GROUP BY RE, building) AS subarea_query
USING (RE, building)
)
/* Single-family properties and qualified sales */
WHERE property_use = 100 AND ((status = 'Qualified' AND improved = 'I') OR status IS NULL)