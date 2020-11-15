SELECT
		(substr(RE,1,6)||' '||substr(RE,7,4)) AS RE,
		mailing_address, mailing_city, mailing_state, property_use, subdivision, neighborhood,
		cap_base_yr, building_val, SUM(DISTINCT(land_val)) AS land_val, just_val - SUM(DISTINCT(land_val)) - building_val AS feature_val, just_val, market_val, assessed_val, 
		just_val - school_taxable AS school_exempt, just_val - county_taxable AS county_exempt, just_val - sjrwnd_taxable AS sjrwnd_exempt, taxing_district, 
		square_feet AS lot_size, heated_sf, UPPER(char_descr) AS char_descr,
		type_descr, style, class, quality, actual_yr_built, effec_yr_built, perc_complete, 
		stories, bedrooms, baths, rooms, 
		Duval.owner, sub1.trans_id, sub1.sale_date, sub1.seller, sub1.owner AS buyer, sub1.price,
		site_address, zipcode,
		boatcv, boatcv_units, boatcv_ppu, boatcv_yr_built,
		carport, carport_units, carport_ppu, carport_yr_built,
		covpatio, covpatio_units, covpatio_ppu, covpatio_yr_built, deck, deck_units, deck_ppu, deck_yr_built, 
		dock, dock_units, dock_ppu, dock_yr_built, 
		fence, fence_units, fence_ppu, fence_yr_built,
		fireplace, fireplace_units, fireplace_ppu, fireplace_yr_built, 
		pool, pool_units, pool_ppu, pool_yr_built, scrporch, scrporch_units, scrporch_ppu, scrporch_yr_built,
		screncl, screncl_units, screncl_ppu, screncl_yr_built, shed, shed_units, shed_ppu, shed_yr_built,
		addition, addition_area, balcony, balcony_area, garage, garage_area, porch, porch_area,
		storage, storage_area, upperstory, avg_upperstory_area
FROM Duval
LEFT JOIN 
(SELECT RE, building, trans_id, sale_date, seller, owner, price
FROM Duval
LEFT JOIN Qualification
ON q_id = qualification
WHERE property_use = 100 AND status = 'Qualified' AND improved = 'I'
GROUP BY trans_id) AS sub1
USING (RE, building)
WHERE property_use = 100
GROUP BY RE, building