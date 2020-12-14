SELECT  substr(Parcel.RE,1,6)||' '||substr(Parcel.RE,7,4) AS RE, building,
		mailing_address_1 AS mail_1, mailing_address_2 AS mail_2, Parcel.city AS mail_city, state AS mail_state, 
		substr(Parcel.zipcode,1,5) AS mail_zipcode,
		subdivision_name AS subdivision, neighborhood, perc_capped, cap_base_yr, building_value, just_value,
		just_value - school_taxable AS school_exempted, just_value - county_taxable AS county_exempted, 
		just_value - sjrwmd_taxable AS sjrwmd_exempted, tax_district, lot_sf, 
		type_descr, style, class, quality, actual_yr_built, effec_yr_built, value AS bldng_val, heated_sf,
		UPPER(char_descr) AS char_descr, 
		stories, bedrooms, baths, rooms, street_num, direction, street_name, street_type, unit, Site.city, Site.zipcode
FROM Parcel
LEFT JOIN Building USING (RE)
LEFT JOIN Character USING (RE)
LEFT JOIN
(SELECT  RE, building,
		SUM(CASE WHEN structure_descr = 'Stories' THEN units
			ELSE NULL END) AS stories,
		SUM(CASE WHEN structure_descr = 'Bedrooms' THEN units
			ELSE NULL END) AS bedrooms,
		SUM(CASE WHEN structure_descr = 'Baths' THEN units
			ELSE NULL END) AS baths,
		SUM(CASE WHEN structure_descr LIKE 'Rooms%Units' THEN units
			ELSE NULL END) AS rooms
FROM Utility
GROUP BY RE, building) AS room_query
USING (RE, building)
LEFT JOIN Site ON Parcel.RE=Site.RE AND building=building_num
WHERE property_use='0100' AND type_descr LIKE '%SFR%'