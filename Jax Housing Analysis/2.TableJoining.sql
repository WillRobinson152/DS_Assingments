SELECT  RE, mailing_address, mailing_city, mailing_state, property_use, subdivision, neighborhood, val_method, cap_base_yr, market_val, assessed_val, building_val, just_val,
		school_taxable, county_taxable, sjrwnd_taxable, taxing_district, square_feet,
		char_descr,
		sub1.building, type_descr, style, class, quality, actual_yr_built, effec_yr_built, perc_complete, value, heated_sf, land_use, zoning, unit_type, units, ppu, land_val,
		stories, bedrooms, baths, rooms, restrooms, avg_story_height,
		owner_line, owner, exem_line, exem_descr, exem_perc, exem_amount, override, 
		trans_id, trans_line, seller, qualification, improved, instr_descr, deed_descr, sale_date, price,
		(street_num||' '||direction||' '||street_name||' '||street_type||' '||unit) AS site_address, zipcode,
		condo_unit, condo_type, condo_value, condo_view_code, condo_perc_adjustment, condo_bedroom, condo_bathroom, condo_area,
		bkhd, bkhd_units, bkhd_ppu, bkhd_yr_built,
		boatcv, boatcv_units, boatcv_ppu, boatcv_yr_built,
		candet, candet_units, candet_ppu, candet_yr_built,
		carport, carport_units, carport_ppu, carport_yr_built,
		covpatio, covpatio_units, covpatio_ppu, covpatio_yr_built,
		deck, deck_units, deck_ppu, deck_yr_built,
		dock, dock_units, dock_ppu, dock_yr_built,
		elevstp, elevstp_units, elevstp_ppu, elevstp_yr_built,
		elevator, elevator_units, elevator_ppu, elevator_yr_built,
		fence, fence_units, fence_ppu, fence_yr_built,
		fireplace, fireplace_units, fireplace_ppu, fireplace_yr_built,
		lightfix, lightfix_units, lightfix_ppu, lightfix_yr_built,
		ltpole, ltpole_units, ltpole_ppu, ltpole_yr_built,
		mezz, mezz_units, mezz_ppu, mezz_yr_built,
		pave, pave_units, pave_ppu, pave_yr_built,
		pool, pool_units, pool_ppu, pool_yr_built,
		scrporch, scrporch_units, scrporch_ppu, scrporch_yr_built,
		screncl, screncl_units, screncl_ppu, screncl_yr_built,
		shed, shed_units, shed_ppu, shed_yr_built,
		addition, addition_area,
		balcony, balcony_area,
		canopy, canopy_area,
		office, office_area,
		garage, garage_area,
		porch, porch_area,
		storage, storage_area,
		upperstory, avg_upperstory_area
FROM
(SELECT  RE,
		CASE WHEN mailing_2 NOT NULL THEN (mailing_1||' '||mailing_2) 
			ELSE mailing_1 END AS mailing_address,
		mailing_city, mailing_state, property_use, subdivision, neighborhood, val_method, cap_base_yr, market_val, assessed_val, building_val, just_val, school_taxable, county_taxable, sjrwnd_taxable, taxing_district, square_feet,
		char_descr,
		IFNULL(building, 0) building, type_descr, style, class, quality, actual_yr_built, effec_yr_built, perc_complete, value, heated_sf,
		use_descr AS land_use, zoning, unit_type, units, ppu, land_val,
		owner_line, owner, exem_line, exem_descr, exem_perc, exem_amount, override,
		trans_id, trans_line, seller, qualification, improved, instr_descr, deed_descr, (year||'-'||month||'-'||day) AS sale_date, price
FROM Parcel
LEFT JOIN Building
USING (RE)
LEFT JOIN Characteristic
USING (RE)
LEFT JOIN Common
USING (RE)
LEFT JOIN 
	(SELECT RE, Owner.line AS owner_line, owner, Exemption.line AS exem_line, exem_descr, exem_perc, exem_amount, override
	FROM Owner
	LEFT JOIN Exemption
	USING (RE, owner))
USING (RE)
LEFT JOIN 
	(SELECT  RE, (or_book||'_'||or_page) AS trans_id, sale_id AS trans_line, seller, qualification, improved, instr_descr, deed_descr, 
			CASE WHEN substr(sale_date,2,1) = '/' THEN ('0'||substr(sale_date,1,1))
					ELSE substr(sale_date,1,2) END AS month,
				CASE WHEN (substr(sale_date,2,1) = '/' AND substr(sale_date,4,1) = '/') THEN ('0'||substr(sale_date,3,1))
					WHEN (substr(sale_date,3,1) = '/' AND substr(sale_date,5,1) = '/') THEN ('0'||substr(sale_date,4,1))
					WHEN (substr(sale_date,3,1) = '/' AND substr(sale_date,6,1) = '/') THEN substr(sale_date,4,2)
					ELSE substr(sale_date,3,2) END AS day,
				substr(sale_date,-4,4) AS year,
			price
	FROM Sale)
USING (RE)) AS sub1
LEFT JOIN
(SELECT RE, street_num, IFNULL(direction,'') direction, street_name, IFNULL(street_type,'') street_type, IFNULL(unit,'') unit, city, substr(zipcode,1,5) AS zipcode, building 
FROM Site)
USING (RE, building)
LEFT JOIN
(SELECT RE, building, unit AS condo_unit, type AS condo_type, value AS condo_value, view_code AS condo_view_code, perc_adjustment AS condo_perc_adjustment, bedroom AS condo_bedroom, bathroom AS condo_bathroom, area AS condo_area
FROM Condo)
USING (RE, building)
LEFT JOIN
(SELECT  RE, building,
		SUM(stories) AS stories, SUM(bedrooms) AS bedrooms, SUM(baths) AS baths, SUM(rooms) AS rooms, SUM(restrooms) AS restrooms, SUM(avg_story_height) AS avg_story_height
FROM
(SELECT  RE, building,
		CASE WHEN structure_descr = 'Stories' THEN unit_count
			ELSE NULL END AS stories,
		CASE WHEN structure_descr = 'Bedrooms' THEN unit_count
			ELSE NULL END AS bedrooms,
		CASE WHEN structure_descr = 'Baths' THEN unit_count
			ELSE NULL END AS baths,
		CASE WHEN structure_descr LIKE 'Rooms%Units' THEN unit_count
			ELSE NULL END AS rooms,
		CASE WHEN structure_descr = 'Restrooms' THEN unit_count
			ELSE NULL END AS restrooms,
		CASE WHEN structure_descr = 'Avg Story Height' THEN unit_count
			ELSE NULL END AS avg_story_height
FROM Utility)
GROUP BY RE, building)
USING (RE, building)
LEFT JOIN
(SELECT  RE,
		building,
		SUM(bkhd) AS bkhd, SUM(bkhd_units) AS bkhd_units, SUM(bkhd_ppu) AS bkhd_ppu, MAX(bkhd_yr_built) AS bkhd_yr_built,
		SUM(boatcv) AS boatcv, SUM(boatcv_units) AS boatcv_units, SUM(boatcv_ppu) AS boatcv_ppu, MAX(boatcv_yr_built) AS boatcv_yr_built,
		SUM(candet) AS candet, SUM(candet_units) AS candet_units, SUM(candet_ppu) AS candet_ppu, MAX(candet_yr_built) AS candet_yr_built,
		SUM(carport) AS carport, SUM(carport_units) AS carport_units, SUM(carport_ppu) AS carport_ppu, MAX(carport_yr_built) AS carport_yr_built,
		SUM(covpatio) AS covpatio, SUM(covpatio_units) AS covpatio_units, SUM(covpatio_ppu) AS covpatio_ppu, MAX(covpatio_yr_built) AS covpatio_yr_built,
		SUM(deck) AS deck, SUM(deck_units) AS deck_units, SUM(deck_ppu) AS deck_ppu, MAX(deck_yr_built) AS deck_yr_built,
		SUM(dock) AS dock, SUM(dock_units) AS dock_units, SUM(dock_ppu) AS dock_ppu, MAX(dock_yr_built) AS dock_yr_built,
		SUM(elevstp) AS elevstp, SUM(elevstp_units) AS elevstp_units, SUM(elevstp_ppu) AS elevstp_ppu, MAX(elevstp_yr_built) AS elevstp_yr_built,
		SUM(elevator) AS elevator, SUM(elevator_units) AS elevator_units, SUM(elevator_ppu) AS elevator_ppu, MAX(elevator_yr_built) AS elevator_yr_built,
		SUM(fence) AS fence, SUM(fence_units) AS fence_units, SUM(fence_ppu) AS fence_ppu, MAX(fence_yr_built) AS fence_yr_built,
		SUM(fireplace) AS fireplace, SUM(fireplace_units) AS fireplace_units, SUM(fireplace_ppu) AS fireplace_ppu, MAX(fireplace_yr_built) AS fireplace_yr_built,
		SUM(lightfix) AS lightfix, SUM(lightfix_units) AS lightfix_units, SUM(lightfix_ppu) AS lightfix_ppu, MAX(lightfix_yr_built) AS lightfix_yr_built,
		SUM(ltpole) AS ltpole, SUM(ltpole_units) AS ltpole_units, SUM(ltpole_ppu) AS ltpole_ppu, MAX(ltpole_yr_built) AS ltpole_yr_built,
		SUM(mezz) AS mezz, SUM(mezz_units) AS mezz_units, SUM(mezz_ppu) AS mezz_ppu, MAX(mezz_yr_built) AS mezz_yr_built,
		SUM(pave) AS pave, SUM(pave_units) AS pave_units, SUM(pave_ppu) AS pave_ppu, MAX(pave_yr_built) AS pave_yr_built,
		SUM(pool) AS pool, SUM(pool_units) AS pool_units, SUM(pool_ppu) AS pool_ppu, MAX(pool_yr_built) AS pool_yr_built,
		SUM(scrporch) AS scrporch, SUM(scrporch_units) AS scrporch_units, SUM(scrporch_ppu) AS scrporch_ppu, MAX(scrporch_yr_built) AS scrporch_yr_built,
		SUM(screncl) AS screncl, SUM(screncl_units) AS screncl_units, SUM(screncl_ppu) AS screncl_ppu, MAX(screncl_yr_built) AS screncl_yr_built,
		SUM(shed) AS shed, SUM(shed_units) AS shed_units, SUM(shed_ppu) AS shed_ppu, MAX(shed_yr_built) AS shed_yr_built
FROM
(SELECT 
	RE,
	building,
	CASE WHEN descr LIKE 'Bkhd%' THEN 1
		ELSE NULL END AS bkhd,
	CASE WHEN descr LIKE 'Bkhd%' THEN units
		ELSE NULL END AS bkhd_units,
	CASE WHEN descr LIKE 'Bkhd%' THEN ppu
		ELSE NULL END AS bkhd_ppu,
	CASE WHEN descr LIKE 'Bkhd%' THEN actual_yr_built
		ELSE NULL END AS bkhd_yr_built,
	CASE WHEN descr LIKE 'Bkhd%' THEN deprec_val
		ELSE NULL END AS bkhd_deprec_val,
	CASE WHEN descr LIKE 'Boat Cv' THEN 1
		ELSE NULL END AS boatcv,
	CASE WHEN descr LIKE 'Boat Cv' THEN units
		ELSE NULL END AS boatcv_units,
	CASE WHEN descr LIKE 'Boat Cv' THEN ppu
		ELSE NULL END AS boatcv_ppu,
	CASE WHEN descr LIKE 'Boat Cv' THEN actual_yr_built
		ELSE NULL END AS boatcv_yr_built,
	CASE WHEN descr LIKE 'Boat Cv' THEN deprec_val
		ELSE NULL END AS boatcv_deprec_val,
	CASE WHEN descr LIKE 'Can Det%' THEN 1
		ELSE NULL END AS candet,
	CASE WHEN descr LIKE 'Can Det%' THEN units
		ELSE NULL END AS candet_units,
	CASE WHEN descr LIKE 'Can Det%' THEN ppu
		ELSE NULL END AS candet_ppu,
	CASE WHEN descr LIKE 'Can Det%' THEN actual_yr_built
		ELSE NULL END AS candet_yr_built,
	CASE WHEN descr LIKE 'Can Det%' THEN deprec_val
		ELSE NULL END AS candet_deprec_val,
	CASE WHEN descr LIKE 'Carport%' THEN 1
		ELSE NULL END AS carport,
	CASE WHEN descr LIKE 'Carport%' THEN units
		ELSE NULL END AS carport_units,
	CASE WHEN descr LIKE 'Carport%' THEN ppu
		ELSE NULL END AS carport_ppu,
	CASE WHEN descr LIKE 'Carport%' THEN actual_yr_built
		ELSE NULL END AS carport_yr_built,
	CASE WHEN descr LIKE 'Carport%' THEN deprec_val
		ELSE NULL END AS carport_deprec_val,
	CASE WHEN descr LIKE 'Cov Pa%' THEN 1
		ELSE NULL END AS covpatio,
	CASE WHEN descr LIKE 'Cov Pat%' THEN units
		ELSE NULL END AS covpatio_units,
	CASE WHEN descr LIKE 'Cov Pat%' THEN ppu
		ELSE NULL END AS covpatio_ppu,
	CASE WHEN descr LIKE 'Cov Pat%' THEN actual_yr_built
		ELSE NULL END AS covpatio_yr_built,
	CASE WHEN descr LIKE 'Cov Pat%' THEN deprec_val
		ELSE NULL END AS covpatio_deprec_val,
	CASE WHEN descr = 'Deck Wd' THEN 1
		ELSE NULL END AS deck,
	CASE WHEN descr = 'Deck Wd' THEN units
		ELSE NULL END AS deck_units,
	CASE WHEN descr = 'Deck Wd' THEN ppu
		ELSE NULL END AS deck_ppu,
	CASE WHEN descr = 'Deck Wd' THEN actual_yr_built
		ELSE NULL END AS deck_yr_built,
	CASE WHEN descr = 'Deck Wd' THEN deprec_val
		ELSE NULL END AS deck_deprec_val,
	CASE WHEN descr LIKE 'Dock%' THEN 1
		ELSE NULL END AS dock,
	CASE WHEN descr LIKE 'Dock%' THEN units
		ELSE NULL END AS dock_units,
	CASE WHEN descr LIKE 'Dock%' THEN ppu
		ELSE NULL END AS dock_ppu,
	CASE WHEN descr LIKE 'Dock%' THEN actual_yr_built
		ELSE NULl END AS dock_yr_built,
	CASE WHEN descr LIKE 'Dock%' THEN deprec_val
		ELSE NULL END AS dock_deprec_val,
	CASE WHEN descr LIKE 'Elev Stp%' THEN 1
		ELSE NULL END AS elevstp,
	CASE WHEN descr LIKE 'Elev Stp%' THEN units
		ELSE NULL END AS elevstp_units,
	CASE WHEN descr LIKE 'Elev Stp%' THEN ppu
		ELSE NULL END AS elevstp_ppu,
	CASE WHEN descr LIKE 'Elev Stp%' THEN actual_yr_built
		ELSE NULL END AS elevstp_yr_built,
	CASE WHEN descr LIKE 'Elev Stp%' THEN deprec_val
		ELSE NULL END AS elevstp_deprec_val,
	CASE WHEN descr LIKE 'Elevator%' THEN 1
		ELSE NULL END AS elevator,
	CASE WHEN descr LIKE 'Elevator%' THEN units
		ELSE NULL END AS elevator_units,
	CASE WHEN descr LIKE 'Elevator%' THEN ppu
		ELSE NULL END AS elevator_ppu,
	CASE WHEN descr LIKE 'Elevator%' THEN actual_yr_built
		ELSE NULL END AS elevator_yr_built,
	CASE WHEN descr LIKE 'Elevator%' THEN deprec_val
		ELSE NULL END AS elevator_deprec_val,
	CASE WHEN descr LIKE 'Fence%' THEN 1
		ELSE NULL END AS fence,
	CASE WHEN descr LIKE 'Fence%' THEN units
		ELSE NULL END AS fence_units,
	CASE WHEN descr LIKE 'Fence%' THEN ppu
		ELSE NULL END AS fence_ppu,
	CASE WHEN descr LIKE 'Fence%' THEN actual_yr_built
		ELSE NULL END AS fence_yr_built,
	CASE WHEN descr LIKE 'Fence%' THEN deprec_val
		ELSE NULL END AS fence_deprec_val,
	CASE WHEN descr LIKE 'Firep%' THEN 1
		ELSE NULL END AS fireplace,
	CASE WHEN descr LIKE 'Firep%' THEN units
		ELSE NULL END AS fireplace_units,
	CASE WHEN descr LIKE 'Firep%' THEN ppu
		ELSE NULL END AS fireplace_ppu,
	CASE WHEN descr LIKE 'Firep%' THEN actual_yr_built
		ELSE NULL END AS fireplace_yr_built,
	CASE WHEN descr LIKE 'Firep%' THEN deprec_val
		ELSE NULL END AS fireplace_deprec_val,
	CASE WHEN descr LIKE 'Light%' THEN 1
		ELSE NULL END AS lightfix,
	CASE WHEN descr LIKE 'Light%' THEN units
		ELSE NULL END AS lightfix_units,
	CASE WHEN descr LIKE 'Light%' THEN ppu
		ELSE NULL END AS lightfix_ppu,
	CASE WHEN descr LIKE 'Light%' THEN actual_yr_built
		ELSE NULL END AS lightfix_yr_built,
	CASE WHEN descr LIKE 'Light%' THEN deprec_val
		ELSE NULL END AS lightfix_deprec_val,
	CASE WHEN descr LIKE 'Lt Pole%' THEN 1
		ELSE NULL END AS ltpole,
	CASE WHEN descr LIKE 'Lt Pole%' THEN units
		ELSE NULL END AS ltpole_units,
	CASE WHEN descr LIKE 'Lt Pole%' THEN ppu
		ELSE NULL END AS ltpole_ppu,
	CASE WHEN descr LIKE 'Lt Pole%' THEN actual_yr_built
		ELSE NULL END AS ltpole_yr_built,
	CASE WHEN descr LIKE 'Lt Pole%' THEN deprec_val
		ELSE NULL END AS ltpole_deprec_val,
	CASE WHEN descr LIKE 'Mezz%' THEN 1
		ELSE NULL END AS mezz,
	CASE WHEN descr LIKE 'Mezz%' THEN units
		ELSE NULL END AS mezz_units,
	CASE WHEN descr LIKE 'Mezz%' THEN ppu
		ELSE NULL END AS mezz_ppu,
	CASE WHEN descr LIKE 'Mezz%' THEN actual_yr_built
		ELSE NULL END AS mezz_yr_built,
	CASE WHEN descr LIKE 'Mezz%' THEN deprec_val
		ELSE NULL END AS mezz_deprec_val,
	CASE WHEN descr LIKE 'Pav%' THEN 1
		ELSE NULL END AS pave,
	CASE WHEN descr LIKE 'Pav%' THEN units
		ELSE NULL END AS pave_units,
	CASE WHEN descr LIKE 'Pav%' THEN ppu
		ELSE NULL END AS pave_ppu,
	CASE WHEN descr LIKE 'Pav%' THEN actual_yr_built
		ELSE NULL END AS pave_yr_built,
	CASE WHEN descr LIKE 'Pav%' THEN deprec_val
		ELSE NULL END AS pave_deprec_val,
	CASE WHEN descr = 'Pool' THEN 1
		ELSE NULL END AS pool,
	CASE WHEN descr = 'Pool' THEN units
		ELSE NULL END AS pool_units,
	CASE WHEN descr = 'Pool' THEN ppu
		ELSE NULL END AS pool_ppu,
	CASE WHEN descr = 'Pool' THEN actual_yr_built
		ELSE NULL END AS pool_yr_built,
	CASE WHEN descr = 'Pool' THEN deprec_val
		ELSE NULL END AS pool_deprec_val,
	CASE WHEN descr LIKE 'Scr Po%' THEN 1
		ELSE NULL END AS scrporch,
	CASE WHEN descr LIKE 'Scr Po%' THEN units
		ELSE NULL END AS scrporch_units,
	CASE WHEN descr LIKE 'Scr Po%' THEN ppu
		ELSE NULL END AS scrporch_ppu,
	CASE WHEN descr LIKE 'Scr Po%' THEN actual_yr_built
		ELSE NULL END AS scrporch_yr_built,
	CASE WHEN descr LIKE 'Scr Po%' THEN deprec_val
		ELSE NULL END AS scrporch_deprec_val,
	CASE WHEN descr LIKE 'Screen%' THEN 1
		ELSE NULL END AS screncl,
	CASE WHEN descr LIKE 'Screen%' THEN units
		ELSE NULL END AS screncl_units,
	CASE WHEN descr LIKE 'Screen%' THEN ppu
		ELSE NULL END AS screncl_ppu,
	CASE WHEN descr LIKE 'Screen%' THEN actual_yr_built
		ELSE NULL END AS screncl_yr_built,
	CASE WHEN descr LIKE 'Screen%' THEN deprec_val
		ELSE NULL END AS screncl_deprec_val,
	CASE WHEN descr LIKE 'Shed%' THEN 1
		ELSE NULL END AS shed,
	CASE WHEN descr LIKE 'Shed%' THEN units
		ELSE NULL END AS shed_units,
	CASE WHEN descr LIKE 'Shed%' THEN ppu
		ELSE NULL END AS shed_ppu,
	CASE WHEN descr LIKE 'Shed%' THEN actual_yr_built
		ELSE NULL END AS shed_yr_built,
	CASE WHEN descr LIKE 'Shed%' THEN deprec_val
		ELSE NULL END AS shed_deprec_val
FROM Feature)
GROUP BY RE, building)
USING (RE, building)
LEFT JOIN 
(SELECT  RE, building,
		SUM(addition) AS addition, SUM(addition_area) AS addition_area,
		SUM(balcony) AS balcony, SUM(balcony_area) AS balcony_area,
		SUM(canopy) AS canopy, SUM(canopy_area) AS canopy_area,
		SUM(office) AS office, SUM(office_area) AS office_area,
		SUM(garage) AS garage, SUM(garage_area) AS garage_area,
		SUM(porch) AS porch, SUM(porch_area) AS porch_area,
		SUM(storage) AS storage, SUM(storage_area) AS storage_area,
		SUM(upperstory) AS upperstory, AVG(upperstory_area) AS avg_upperstory_area
FROM
(SELECT  RE, building,
		CASE WHEN sub_structure_descr = 'Addition' THEN 1
			ELSE NULL END AS addition,
		CASE WHEN sub_structure_descr = 'Addition' THEN actual_area
			ELSE NULL END AS addition_area,
		CASE WHEN sub_structure_descr = 'Balcony' THEN 1
			ELSE NULL END AS balcony,
		CASE WHEN sub_structure_descr = 'Balcony' THEN actual_area
			ELSE NULL END AS balcony_area,
		CASE WHEN sub_structure_descr LIKE 'Canopy%' THEN 1
			ELSE NULL END AS canopy,
		CASE WHEN sub_structure_descr LIKE 'Canopy%' THEN actual_area
			ELSE NULL END AS canopy_area,
		CASE WHEN sub_structure_descr LIKE '%Office' THEN 1
			ELSE NULL END AS office,
		CASE WHEN sub_structure_descr LIKE '%Office' THEN actual_area
			ELSE NULL END AS office_area,
		CASE WHEN sub_structure_descr LIKE 'Fin%Garage' THEN 1
			ELSE NULL END AS garage,
		CASE WHEN sub_structure_descr LIKE 'Fin%Garage' THEN actual_area
			ELSE NULL END AS garage_area,
		CASE WHEN sub_structure_descr LIKE 'Fin%Porch' THEN 1
			ELSE NULL END AS porch,
		CASE WHEN sub_structure_descr LIKE 'Fin%Porch' THEN actual_area
			ELSE NULL END AS porch_area,
		CASE WHEN sub_structure_descr LIKE 'Fin%Storage' THEN 1
			ELSE NULL END AS storage,
		CASE WHEN sub_structure_descr LIKE 'Fin%Storage' THEN actual_area
			ELSE NULL END AS storage_area,
		CASE WHEN sub_structure_descr LIKE 'Finished upper story%' THEN 1
			ELSE NULL END AS upperstory,
		CASE WHEN sub_structure_descr LIKE 'Finished upper story%' THEN actual_area
			ELSE NULL END AS upperstory_area
FROM Subarea)
GROUP BY RE, building)
USING (RE, building)