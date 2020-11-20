/* Final query (filter in bottom WHERE clause) */
SELECT *
FROM
(
SELECT  
		(SUBSTR(RE,1,6)||' '||SUBSTR(RE,7,4)) AS RE,
		/* Owner table query */
		IFNULL(owner_1, 'NA') AS owner_1, IFNULL(owner_2, 'NA') AS owner_2, IFNULL(owner_3, 'NA') AS owner_3,
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
		IFNULL(char_1,'NONE') AS char_1, IFNULL(char_2, 'NONE') AS char_2, IFNULL(char_3,'NONE') AS char_3,
		/* Building table query */
		IFNULL(building, 0) AS building, IFNULL(type_descr, 'VACANT') AS type_descr, IFNULL(style,'NA') AS style, 
		IFNULL(class,'NA') AS class, IFNULL(quality,'NA') AS quality, IFNULL(actual_yr_built,0) AS actual_yr_built,
		IFNULL(effec_yr_built,0) AS effec_yr_built, IFNULL(perc_complete,0.0) AS perc_complete, 
		IFNULL(value,0) AS value, IFNULL(heated_sf,0) AS heated_sf,
		/* Utility table query */
		IFNULL(stories, 0.0) AS stories, IFNULL(bedrooms, 0.0) AS bedrooms, IFNULL(baths, 0.0) AS baths,
		IFNULL(rooms, 0.0) AS rooms, IFNULL(restrooms, 0.0) AS restrooms, IFNULL(avg_story_height, 0.0) AS avg_story_height,
		/* Common table query */
		IFNULL(landuse_1,'NONE') AS landuse_1, IFNULL(zoning_1,'NONE') AS zoning_1, 
		IFNULL(unit_type_1,'NONE') AS unit_type_1, IFNULL(units_1,0.0) AS units_1, 
		IFNULL(land_val_1,0) AS land_val_1,
		IFNULL(landuse_2,'NONE') AS landuse_2, IFNULL(zoning_2,'NONE') AS zoning_2, 
		IFNULL(unit_type_2,'NONE') AS unit_type_2, IFNULL(units_2,0.0) AS units_2, 
		IFNULL(land_val_2,0) AS land_val_2,
		IFNULL(landuse_3,'NONE') AS landuse_3, IFNULL(zoning_3,'NONE') AS zoning_3, 
		IFNULL(unit_type_3,'NONE') AS unit_type_3, IFNULL(units_3,0.0) AS units_3, 
		IFNULL(land_val_3,0) AS land_val_3,
		IFNULL(landuse_4,'NONE') AS landuse_4, IFNULL(zoning_4,'NONE') AS zoning_4, 
		IFNULL(unit_type_4,'NONE') AS unit_type_4, IFNULL(units_4,0.0) AS units_4, 
		IFNULL(land_val_4,0) AS land_val_4,
		IFNULL(landuse_5,'NONE') AS landuse_5, IFNULL(zoning_5,'NONE') AS zoning_5, 
		IFNULL(unit_type_5,'NONE') AS unit_type_5, IFNULL(units_5,0.0) AS units_5, 
		IFNULL(land_val_5,0) AS land_val_5,
		IFNULL(landuse_6,'NONE') AS landuse_6, IFNULL(zoning_6,'NONE') AS zoning_6, 
		IFNULL(unit_type_6,'NONE') AS unit_type_6, IFNULL(units_6,0.0) AS units_6, 
		IFNULL(land_val_6,0) AS land_val_6,
		IFNULL(landuse_7,'NONE') AS landuse_7, IFNULL(zoning_7,'NONE') AS zoning_7, 
		IFNULL(unit_type_7,'NONE') AS unit_type_7, IFNULL(units_7,0.0) AS units_7, 
		IFNULL(land_val_7,0) AS land_val_7,
		IFNULL(landuse_8,'NONE') AS landuse_8, IFNULL(zoning_8,'NONE') AS zoning_8, 
		IFNULL(unit_type_8,'NONE') AS unit_type_8, IFNULL(units_8,0.0) AS units_8, 
		IFNULL(land_val_8,0) AS land_val_8,
		IFNULL(landuse_9,'NONE') AS landuse_9, IFNULL(zoning_9,'NONE') AS zoning_9, 
		IFNULL(unit_type_9,'NONE') AS unit_type_9, IFNULL(units_9,0.0) AS units_9, 
		IFNULL(land_val_9,0) AS land_val_9,
		IFNULL(landuse_10,'NONE') AS landuse_10, IFNULL(zoning_10,'NONE') AS zoning_10, 
		IFNULL(unit_type_10,'NONE') AS unit_type_10, IFNULL(units_10,0.0) AS units_10, 
		IFNULL(land_val_10,0) AS land_val_10,
		/* Sales table query */
		IFNULL(trans_id,'NONE') AS trans_id, IFNULL(status,'NONE') AS status, IFNULL(reason,'NONE') AS reason, 
		IFNULL(sale_date,'0000-00-00') AS sale_date, IFNULL(seller_1,'NONE') AS seller_1, 
		IFNULL(seller_2,'NONE') AS seller_2, IFNULL(improved,'NONE') AS improved, IFNULL(price,0) AS price,
		/* Feature table query */
		IFNULL(feat1,'NONE') AS feat1, IFNULL(feat1_grade,0.0) AS feat1_grade,
		IFNULL(feat1_units,0.0) AS feat1_units, IFNULL(feat1_ppu, 0.0) AS feat1_ppu,
		IFNULL(feat1_yr_built,0) AS feat1_yr_built, IFNULL(feat1_deprec_val, 0) AS feat1_deprec_val,
		IFNULL(feat2,'NONE') AS feat2, IFNULL(feat2_grade,0.0) AS feat2_grade,
		IFNULL(feat2_units,0.0) AS feat2_units, IFNULL(feat2_ppu, 0.0) AS feat2_ppu,
		IFNULL(feat2_yr_built,0) AS feat2_yr_built, IFNULL(feat2_deprec_val, 0) AS feat2_deprec_val,
		IFNULL(feat3,'NONE') AS feat3, IFNULL(feat3_grade,0.0) AS feat3_grade,
		IFNULL(feat3_units,0.0) AS feat3_units, IFNULL(feat3_ppu, 0.0) AS feat3_ppu,
		IFNULL(feat3_yr_built,0) AS feat3_yr_built, IFNULL(feat3_deprec_val, 0) AS feat3_deprec_val,
		IFNULL(feat4,'NONE') AS feat4, IFNULL(feat4_grade,0.0) AS feat4_grade,
		IFNULL(feat4_units,0.0) AS feat4_units, IFNULL(feat4_ppu, 0.0) AS feat4_ppu,
		IFNULL(feat4_yr_built,0) AS feat4_yr_built, IFNULL(feat4_deprec_val, 0) AS feat4_deprec_val,
		IFNULL(feat5,'NONE') AS feat5, IFNULL(feat5_grade,0.0) AS feat5_grade,
		IFNULL(feat5_units,0.0) AS feat5_units, IFNULL(feat5_ppu, 0.0) AS feat5_ppu,
		IFNULL(feat5_yr_built,0) AS feat5_yr_built, IFNULL(feat5_deprec_val, 0) AS feat5_deprec_val,
		IFNULL(feat6,'NONE') AS feat6, IFNULL(feat6_grade,0.0) AS feat6_grade,
		IFNULL(feat6_units,0.0) AS feat6_units, IFNULL(feat6_ppu, 0.0) AS feat6_ppu,
		IFNULL(feat6_yr_built,0) AS feat6_yr_built, IFNULL(feat6_deprec_val, 0) AS feat6_deprec_val,
		IFNULL(feat7,'NONE') AS feat7, IFNULL(feat7_grade,0.0) AS feat7_grade,
		IFNULL(feat7_units,0.0) AS feat7_units, IFNULL(feat7_ppu, 0.0) AS feat7_ppu,
		IFNULL(feat7_yr_built,0) AS feat7_yr_built, IFNULL(feat7_deprec_val, 0) AS feat7_deprec_val,
		IFNULL(feat8,'NONE') AS feat8, IFNULL(feat8_grade,0.0) AS feat8_grade,
		IFNULL(feat8_units,0.0) AS feat8_units, IFNULL(feat8_ppu, 0.0) AS feat8_ppu,
		IFNULL(feat8_yr_built,0) AS feat8_yr_built, IFNULL(feat8_deprec_val, 0) AS feat8_deprec_val,
		IFNULL(feat9,'NONE') AS feat9, IFNULL(feat9_grade,0.0) AS feat9_grade,
		IFNULL(feat9_units,0.0) AS feat9_units, IFNULL(feat9_ppu, 0.0) AS feat9_ppu,
		IFNULL(feat9_yr_built,0) AS feat9_yr_built, IFNULL(feat9_deprec_val, 0) AS feat9_deprec_val,
		IFNULL(feat10,'NONE') AS feat10, IFNULL(feat10_grade,0.0) AS feat10_grade,
		IFNULL(feat10_units,0.0) AS feat10_units, IFNULL(feat10_ppu, 0.0) AS feat10_ppu,
		IFNULL(feat10_yr_built,0) AS feat10_yr_built, IFNULL(feat10_deprec_val, 0) AS feat10_deprec_val,
		IFNULL(feat11,'NONE') AS feat11, IFNULL(feat11_grade,0.0) AS feat11_grade,
		IFNULL(feat11_units,0.0) AS feat11_units, IFNULL(feat11_ppu, 0.0) AS feat11_ppu,
		IFNULL(feat11_yr_built,0) AS feat11_yr_built, IFNULL(feat11_deprec_val, 0) AS feat11_deprec_val,
		IFNULL(feat12,'NONE') AS feat12, IFNULL(feat12_grade,0.0) AS feat12_grade,
		IFNULL(feat12_units,0.0) AS feat12_units, IFNULL(feat12_ppu, 0.0) AS feat12_ppu,
		IFNULL(feat12_yr_built,0) AS feat12_yr_built, IFNULL(feat12_deprec_val, 0) AS feat12_deprec_val,
		IFNULL(feat13,'NONE') AS feat13, IFNULL(feat13_grade,0.0) AS feat13_grade,
		IFNULL(feat13_units,0.0) AS feat13_units, IFNULL(feat13_ppu, 0.0) AS feat13_ppu,
		IFNULL(feat13_yr_built,0) AS feat13_yr_built, IFNULL(feat13_deprec_val, 0) AS feat13_deprec_val,
		IFNULL(feat14,'NONE') AS feat14, IFNULL(feat14_grade,0.0) AS feat14_grade,
		IFNULL(feat14_units,0.0) AS feat14_units, IFNULL(feat14_ppu, 0.0) AS feat14_ppu,
		IFNULL(feat14_yr_built,0) AS feat14_yr_built, IFNULL(feat14_deprec_val, 0) AS feat14_deprec_val,
		IFNULL(feat15,'NONE') AS feat15, IFNULL(feat15_grade,0.0) AS feat15_grade,
		IFNULL(feat15_units,0.0) AS feat15_units, IFNULL(feat15_ppu, 0.0) AS feat15_ppu,
		IFNULL(feat15_yr_built,0) AS feat15_yr_built, IFNULL(feat15_deprec_val, 0) AS feat15_deprec_val,
		IFNULL(feat16,'NONE') AS feat16, IFNULL(feat16_grade,0.0) AS feat16_grade,
		IFNULL(feat16_units,0.0) AS feat16_units, IFNULL(feat16_ppu, 0.0) AS feat16_ppu,
		IFNULL(feat16_yr_built,0) AS feat16_yr_built, IFNULL(feat16_deprec_val, 0) AS feat16_deprec_val,
		IFNULL(feat17,'NONE') AS feat17, IFNULL(feat17_grade,0.0) AS feat17_grade,
		IFNULL(feat17_units,0.0) AS feat17_units, IFNULL(feat17_ppu, 0.0) AS feat17_ppu,
		IFNULL(feat17_yr_built,0) AS feat17_yr_built, IFNULL(feat17_deprec_val, 0) AS feat17_deprec_val,
		IFNULL(feat18,'NONE') AS feat18, IFNULL(feat18_grade,0.0) AS feat18_grade,
		IFNULL(feat18_units,0.0) AS feat18_units, IFNULL(feat18_ppu, 0.0) AS feat18_ppu,
		IFNULL(feat18_yr_built,0) AS feat18_yr_built, IFNULL(feat18_deprec_val, 0) AS feat18_deprec_val,
		IFNULL(feat19,'NONE') AS feat19, IFNULL(feat19_grade,0.0) AS feat19_grade,
		IFNULL(feat19_units,0.0) AS feat19_units, IFNULL(feat19_ppu, 0.0) AS feat19_ppu,
		IFNULL(feat19_yr_built,0) AS feat19_yr_built, IFNULL(feat19_deprec_val, 0) AS feat19_deprec_val,
		IFNULL(feat1,'NONE') AS feat20, IFNULL(feat20_grade,0.0) AS feat20_grade,
		IFNULL(feat20_units,0.0) AS feat20_units, IFNULL(feat20_ppu, 0.0) AS feat20_ppu,
		IFNULL(feat20_yr_built,0) AS feat20_yr_built, IFNULL(feat20_deprec_val, 0) AS feat20_deprec_val,
		IFNULL(feat21,'NONE') AS feat21, IFNULL(feat21_grade,0.0) AS feat21_grade,
		IFNULL(feat21_units,0.0) AS feat21_units, IFNULL(feat21_ppu, 0.0) AS feat21_ppu,
		IFNULL(feat21_yr_built,0) AS feat21_yr_built, IFNULL(feat21_deprec_val, 0) AS feat21_deprec_val,
		IFNULL(feat22,'NONE') AS feat22, IFNULL(feat22_grade,0.0) AS feat22_grade,
		IFNULL(feat22_units,0.0) AS feat22_units, IFNULL(feat22_ppu, 0.0) AS feat22_ppu,
		IFNULL(feat22_yr_built,0) AS feat22_yr_built, IFNULL(feat22_deprec_val, 0) AS feat22_deprec_val,
		IFNULL(feat23,'NONE') AS feat23, IFNULL(feat23_grade,0.0) AS feat23_grade,
		IFNULL(feat23_units,0.0) AS feat23_units, IFNULL(feat23_ppu, 0.0) AS feat23_ppu,
		IFNULL(feat23_yr_built,0) AS feat23_yr_built, IFNULL(feat23_deprec_val, 0) AS feat23_deprec_val,
		/* Subarea table query */
		IFNULL(sub1,'NONE') AS sub1, IFNULL(sub1_actualarea,0) AS sub1_actualarea,
		IFNULL(sub1_effecarea,0) AS sub1_effecarea, IFNULL(sub1_heatedarea,0) AS sub1_heatedarea,
		IFNULL(sub1,'NONE') AS sub2, IFNULL(sub2_actualarea,0) AS sub2_actualarea,
		IFNULL(sub2_effecarea,0) AS sub2_effecarea, IFNULL(sub2_heatedarea,0) AS sub2_heatedarea,
		IFNULL(sub3,'NONE') AS sub3, IFNULL(sub3_actualarea,0) AS sub3_actualarea,
		IFNULL(sub3_effecarea,0) AS sub3_effecarea, IFNULL(sub3_heatedarea,0) AS sub3_heatedarea,
		IFNULL(sub4,'NONE') AS sub4, IFNULL(sub4_actualarea,0) AS sub4_actualarea,
		IFNULL(sub4_effecarea,0) AS sub4_effecarea, IFNULL(sub4_heatedarea,0) AS sub4_heatedarea,
		IFNULL(sub5,'NONE') AS sub5, IFNULL(sub5_actualarea,0) AS sub5_actualarea,
		IFNULL(sub5_effecarea,0) AS sub5_effecarea, IFNULL(sub5_heatedarea,0) AS sub5_heatedarea,
		IFNULL(sub6,'NONE') AS sub6, IFNULL(sub6_actualarea,0) AS sub6_actualarea,
		IFNULL(sub6_effecarea,0) AS sub6_effecarea, IFNULL(sub6_heatedarea,0) AS sub6_heatedarea,
		IFNULL(sub7,'NONE') AS sub7, IFNULL(sub7_actualarea,0) AS sub7_actualarea,
		IFNULL(sub7_effecarea,0) AS sub7_effecarea, IFNULL(sub7_heatedarea,0) AS sub7_heatedarea,
		IFNULL(sub8,'NONE') AS sub8, IFNULL(sub8_actualarea,0) AS sub8_actualarea,
		IFNULL(sub8_effecarea,0) AS sub8_effecarea, IFNULL(sub8_heatedarea,0) AS sub8_heatedarea,
		IFNULL(sub9,'NONE') AS sub9, IFNULL(sub9_actualarea,0) AS sub9_actualarea,
		IFNULL(sub9_effecarea,0) AS sub9_effecarea, IFNULL(sub9_heatedarea,0) AS sub9_heatedarea,
		IFNULL(sub10,'NONE') AS sub10, IFNULL(sub10_actualarea,0) AS sub10_actualarea,
		IFNULL(sub10_effecarea,0) AS sub10_effecarea, IFNULL(sub10_heatedarea,0) AS sub10_heatedarea,
		IFNULL(sub11,'NONE') AS sub11, IFNULL(sub11_actualarea,0) AS sub11_actualarea,
		IFNULL(sub11_effecarea,0) AS sub11_effecarea, IFNULL(sub11_heatedarea,0) AS sub11_heatedarea,
		IFNULL(sub12,'NONE') AS sub12, IFNULL(sub12_actualarea,0) AS sub12_actualarea,
		IFNULL(sub12_effecarea,0) AS sub12_effecarea, IFNULL(sub12_heatedarea,0) AS sub12_heatedarea,
		IFNULL(sub13,'NONE') AS sub13, IFNULL(sub13_actualarea,0) AS sub13_actualarea,
		IFNULL(sub13_effecarea,0) AS sub13_effecarea, IFNULL(sub13_heatedarea,0) AS sub13_heatedarea,
		IFNULL(sub14,'NONE') AS sub14, IFNULL(sub13_actualarea,0) AS sub13_actualarea,
		IFNULL(sub14_effecarea,0) AS sub14_effecarea, IFNULL(sub14_heatedarea,0) AS sub14_heatedarea,
		IFNULL(sub15,'NONE') AS sub15, IFNULL(sub15_actualarea,0) AS sub15_actualarea,
		IFNULL(sub15_effecarea,0) AS sub15_effecarea, IFNULL(sub15_heatedarea,0) AS sub15_heatedarea,
		IFNULL(sub16,'NONE') AS sub16, IFNULL(sub16_actualarea,0) AS sub16_actualarea,
		IFNULL(sub16_effecarea,0) AS sub16_effecarea, IFNULL(sub16_heatedarea,0) AS sub16_heatedarea,
		IFNULL(sub17,'NONE') AS sub17, IFNULL(sub17_actualarea,0) AS sub17_actualarea,
		IFNULL(sub17_effecarea,0) AS sub17_effecarea, IFNULL(sub17_heatedarea,0) AS sub17_heatedarea,
		IFNULL(sub18,'NONE') AS sub18, IFNULL(sub18_actualarea,0) AS sub18_actualarea,
		IFNULL(sub18_effecarea,0) AS sub18_effecarea, IFNULL(sub18_heatedarea,0) AS sub18_heatedarea,
		IFNULL(sub19,'NONE') AS sub19, IFNULL(sub19_actualarea,0) AS sub19_actualarea,
		IFNULL(sub19_effecarea,0) AS sub19_effecarea, IFNULL(sub19_heatedarea,0) AS sub19_heatedarea,
		IFNULL(sub20,'NONE') AS sub20, IFNULL(sub20_actualarea,0) AS sub20_actualarea,
		IFNULL(sub20_effecarea,0) AS sub20_effecarea, IFNULL(sub20_heatedarea,0) AS sub20_heatedarea,
		IFNULL(sub21,'NONE') AS sub21, IFNULL(sub21_actualarea,0) AS sub21_actualarea,
		IFNULL(sub21_effecarea,0) AS sub21_effecarea, IFNULL(sub21_heatedarea,0) AS sub21heated_area
-- 		owner_line, owner, exem_line, exem_descr, exem_perc, exem_amount, override,

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
			ELSE NULL END) AS rooms,
		SUM(CASE WHEN structure_descr = 'Restrooms' THEN unit_count
			ELSE NULL END) AS restrooms,
		SUM(CASE WHEN structure_descr = 'Avg Story Height' THEN unit_count
			ELSE NULL END) AS avg_story_height
FROM Utility
GROUP BY RE, building) AS room_query
USING (RE, building)
/* Characteristic table query */
LEFT JOIN
(SELECT  RE, UPPER(char_1) AS char_1, 
		CASE WHEN char_2 <> char_1 THEN UPPER(char_2)
			WHEN char_3 <> char_1 THEN UPPER(char_3)
			ELSE 'NONE' END AS char_2, 
		CASE WHEN char_3 <> char_1 AND char_3 <> char_2 THEN UPPER(char_3) 
			ELSE 'NONE' END AS char_3
FROM
(
SELECT RE, char_descr AS char_1
FROM
(SELECT RE, char_descr, ROW_NUMBER() OVER (PARTITION BY RE) AS RowNum
FROM Characteristic)
WHERE RowNum = 1
)
LEFT JOIN
(
SELECT RE, char_descr AS char_2
FROM
(SELECT RE, char_descr, ROW_NUMBER() OVER (PARTITION BY RE) AS RowNum
FROM Characteristic)
WHERE RowNum = 2
)
USING (RE)
LEFT JOIN
(
SELECT RE, char_descr AS char_3
FROM
(SELECT RE, char_descr, ROW_NUMBER() OVER (PARTITION BY RE) AS RowNum
FROM Characteristic)
WHERE RowNum = 3
)
USING (RE)) AS proximity_sub
USING (RE) 
/* Common table query */
LEFT JOIN
(SELECT  RE,
		MAX(CASE WHEN RowNum = 1 THEN use_descr
			ELSE NULL END) AS landuse_1,
		MAX(CASE WHEN RowNum = 1 THEN zoning
			ELSE NULL END) AS zoning_1,
		MAX(CASE WHEN RowNum = 1 THEN unit_type
			ELSE NULL END) AS unit_type_1,
		MAX(CASE WHEN RowNum = 1 THEN units
			ELSE NULL END) AS units_1,
		MAX(CASE WHEN RowNum = 1 THEN land_val
			ELSE NULL END) AS land_val_1,
		MAX(CASE WHEN RowNum = 2 THEN use_descr
			ELSE NULL END) AS landuse_2,
		MAX(CASE WHEN RowNum = 2 THEN zoning
			ELSE NULL END) AS zoning_2,
		MAX(CASE WHEN RowNum = 2 THEN unit_type
			ELSE NULL END) AS unit_type_2,
		MAX(CASE WHEN RowNum = 2 THEN units
			ELSE NULL END) AS units_2,
		MAX(CASE WHEN RowNum = 2 THEN land_val
			ELSE NULL END) AS land_val_2,
		MAX(CASE WHEN RowNum = 3 THEN use_descr
			ELSE NULL END) AS landuse_3,
		MAX(CASE WHEN RowNum = 3 THEN zoning
			ELSE NULL END) AS zoning_3,
		MAX(CASE WHEN RowNum = 3 THEN unit_type
			ELSE NULL END) AS unit_type_3,
		MAX(CASE WHEN RowNum = 3 THEN units
			ELSE NULL END) AS units_3,
		MAX(CASE WHEN RowNum = 3 THEN land_val
			ELSE NULL END) AS land_val_3,
		MAX(CASE WHEN RowNum = 4 THEN use_descr
			ELSE NULL END) AS landuse_4,
		MAX(CASE WHEN RowNum = 4 THEN zoning
			ELSE NULL END) AS zoning_4,
		MAX(CASE WHEN RowNum = 4 THEN unit_type
			ELSE NULL END) AS unit_type_4,
		MAX(CASE WHEN RowNum = 4 THEN units
			ELSE NULL END) AS units_4,
		MAX(CASE WHEN RowNum = 4 THEN land_val
			ELSE NULL END) AS land_val_4,
		MAX(CASE WHEN RowNum = 5 THEN use_descr
			ELSE NULL END) AS landuse_5,
		MAX(CASE WHEN RowNum = 5 THEN zoning
			ELSE NULL END) AS zoning_5,
		MAX(CASE WHEN RowNum = 5 THEN unit_type
			ELSE NULL END) AS unit_type_5,
		MAX(CASE WHEN RowNum = 5 THEN units
			ELSE NULL END) AS units_5,
		MAX(CASE WHEN RowNum = 5 THEN land_val
			ELSE NULL END) AS land_val_5,
		MAX(CASE WHEN RowNum = 6 THEN use_descr
			ELSE NULL END) AS landuse_6,
		MAX(CASE WHEN RowNum = 6 THEN zoning
			ELSE NULL END) AS zoning_6,
		MAX(CASE WHEN RowNum = 6 THEN unit_type
			ELSE NULL END) AS unit_type_6,
		MAX(CASE WHEN RowNum = 6 THEN units
			ELSE NULL END) AS units_6,
		MAX(CASE WHEN RowNum = 6 THEN land_val
			ELSE NULL END) AS land_val_6,
		MAX(CASE WHEN RowNum = 7 THEN use_descr
			ELSE NULL END) AS landuse_7,
		MAX(CASE WHEN RowNum = 7 THEN zoning
			ELSE NULL END) AS zoning_7,
		MAX(CASE WHEN RowNum = 7 THEN unit_type
			ELSE NULL END) AS unit_type_7,
		MAX(CASE WHEN RowNum = 7 THEN units
			ELSE NULL END) AS units_7,
		MAX(CASE WHEN RowNum = 7 THEN land_val
			ELSE NULL END) AS land_val_7,
		MAX(CASE WHEN RowNum = 8 THEN use_descr
			ELSE NULL END) AS landuse_8,
		MAX(CASE WHEN RowNum = 8 THEN zoning
			ELSE NULL END) AS zoning_8,
		MAX(CASE WHEN RowNum = 8 THEN unit_type
			ELSE NULL END) AS unit_type_8,
		MAX(CASE WHEN RowNum = 8 THEN units
			ELSE NULL END) AS units_8,
		MAX(CASE WHEN RowNum = 8 THEN land_val
			ELSE NULL END) AS land_val_8,
		MAX(CASE WHEN RowNum = 9 THEN use_descr
			ELSE NULL END) AS landuse_9,
		MAX(CASE WHEN RowNum = 9 THEN zoning
			ELSE NULL END) AS zoning_9,
		MAX(CASE WHEN RowNum = 9 THEN unit_type
			ELSE NULL END) AS unit_type_9,
		MAX(CASE WHEN RowNum = 9 THEN units
			ELSE NULL END) AS units_9,
		MAX(CASE WHEN RowNum = 9 THEN land_val
			ELSE NULL END) AS land_val_9,
		MAX(CASE WHEN RowNum = 10 THEN use_descr
			ELSE NULL END) AS landuse_10,
		MAX(CASE WHEN RowNum = 10 THEN zoning
			ELSE NULL END) AS zoning_10,
		MAX(CASE WHEN RowNum = 10 THEN unit_type
			ELSE NULL END) AS unit_type_10,
		MAX(CASE WHEN RowNum = 10 THEN units
			ELSE NULL END) AS units_10,
		MAX(CASE WHEN RowNum = 10 THEN land_val
			ELSE NULL END) AS land_val_10	
FROM
(SELECT RE, use_descr, zoning, unit_type, units, land_val,
		ROW_NUMBER() OVER (PARTITION BY RE) AS RowNum
FROM Common)
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
(SELECT RE, building,
		MAX(CASE WHEN RowNum = 1 THEN descr
			ELSE NULL END) AS feat1,
		MAX(CASE WHEN RowNum = 1 THEN grade
			ELSE NULL END) AS feat1_grade,
		MAX(CASE WHEN RowNum = 1 THEN units
			ELSE NULL END) AS feat1_units,
		MAX(CASE WHEN RowNum = 1 THEN ppu
			ELSE NULL END) AS feat1_ppu,
		MAX(CASE WHEN RowNum = 1 THEN actual_yr_built
			ELSE NULL END) AS feat1_yr_built,
		MAX(CASE WHEN RowNum = 1 THEN deprec_val
			ELSE NULL END) AS feat1_deprec_val,
		MAX(CASE WHEN RowNum = 2 THEN descr
			ELSE NULL END) AS feat2,
		MAX(CASE WHEN RowNum = 2 THEN grade
			ELSE NULL END) AS feat2_grade,
		MAX(CASE WHEN RowNum = 2 THEN units
			ELSE NULL END) AS feat2_units,
		MAX(CASE WHEN RowNum = 2 THEN ppu
			ELSE NULL END) AS feat2_ppu,
		MAX(CASE WHEN RowNum = 2 THEN actual_yr_built
			ELSE NULL END) AS feat2_yr_built,
		MAX(CASE WHEN RowNum = 2 THEN deprec_val
			ELSE NULL END) AS feat2_deprec_val,
		MAX(CASE WHEN RowNum = 3 THEN descr
			ELSE NULL END) AS feat3,
		MAX(CASE WHEN RowNum = 3 THEN grade
			ELSE NULL END) AS feat3_grade,
		MAX(CASE WHEN RowNum = 3 THEN units
			ELSE NULL END) AS feat3_units,
		MAX(CASE WHEN RowNum = 3 THEN ppu
			ELSE NULL END) AS feat3_ppu,
		MAX(CASE WHEN RowNum = 3 THEN actual_yr_built
			ELSE NULL END) AS feat3_yr_built,
		MAX(CASE WHEN RowNum = 3 THEN deprec_val
			ELSE NULL END) AS feat3_deprec_val,
		MAX(CASE WHEN RowNum = 4 THEN descr
			ELSE NULL END) AS feat4,
		MAX(CASE WHEN RowNum = 4 THEN grade
			ELSE NULL END) AS feat4_grade,
		MAX(CASE WHEN RowNum = 4 THEN units
			ELSE NULL END) AS feat4_units,
		MAX(CASE WHEN RowNum = 4 THEN ppu
			ELSE NULL END) AS feat4_ppu,
		MAX(CASE WHEN RowNum = 4 THEN actual_yr_built
			ELSE NULL END) AS feat4_yr_built,
		MAX(CASE WHEN RowNum = 4 THEN deprec_val
			ELSE NULL END) AS feat4_deprec_val,
		MAX(CASE WHEN RowNum = 5 THEN descr
			ELSE NULL END) AS feat5,
		MAX(CASE WHEN RowNum = 5 THEN grade
			ELSE NULL END) AS feat5_grade,
		MAX(CASE WHEN RowNum = 5 THEN units
			ELSE NULL END) AS feat5_units,
		MAX(CASE WHEN RowNum = 5 THEN ppu
			ELSE NULL END) AS feat5_ppu,
		MAX(CASE WHEN RowNum = 5 THEN actual_yr_built
			ELSE NULL END) AS feat5_yr_built,
		MAX(CASE WHEN RowNum = 5 THEN deprec_val
			ELSE NULL END) AS feat5_deprec_val,
		MAX(CASE WHEN RowNum = 6 THEN descr
			ELSE NULL END) AS feat6,
		MAX(CASE WHEN RowNum = 6 THEN grade
			ELSE NULL END) AS feat6_grade,
		MAX(CASE WHEN RowNum = 6 THEN units
			ELSE NULL END) AS feat6_units,
		MAX(CASE WHEN RowNum = 6 THEN ppu
			ELSE NULL END) AS feat6_ppu,
		MAX(CASE WHEN RowNum = 6 THEN actual_yr_built
			ELSE NULL END) AS feat6_yr_built,
		MAX(CASE WHEN RowNum = 6 THEN deprec_val
			ELSE NULL END) AS feat6_deprec_val,
		MAX(CASE WHEN RowNum = 7 THEN descr
			ELSE NULL END) AS feat7,
		MAX(CASE WHEN RowNum = 7 THEN grade
			ELSE NULL END) AS feat7_grade,
		MAX(CASE WHEN RowNum = 7 THEN units
			ELSE NULL END) AS feat7_units,
		MAX(CASE WHEN RowNum = 7 THEN ppu
			ELSE NULL END) AS feat7_ppu,
		MAX(CASE WHEN RowNum = 7 THEN actual_yr_built
			ELSE NULL END) AS feat7_yr_built,
		MAX(CASE WHEN RowNum = 7 THEN deprec_val
			ELSE NULL END) AS feat7_deprec_val,
		MAX(CASE WHEN RowNum = 8 THEN descr
			ELSE NULL END) AS feat8,
		MAX(CASE WHEN RowNum = 8 THEN grade
			ELSE NULL END) AS feat8_grade,
		MAX(CASE WHEN RowNum = 8 THEN units
			ELSE NULL END) AS feat8_units,
		MAX(CASE WHEN RowNum = 8 THEN ppu
			ELSE NULL END) AS feat8_ppu,
		MAX(CASE WHEN RowNum = 8 THEN actual_yr_built
			ELSE NULL END) AS feat8_yr_built,
		MAX(CASE WHEN RowNum = 8 THEN deprec_val
			ELSE NULL END) AS feat8_deprec_val,
		MAX(CASE WHEN RowNum = 9 THEN descr
			ELSE NULL END) AS feat9,
		MAX(CASE WHEN RowNum = 9 THEN grade
			ELSE NULL END) AS feat9_grade,
		MAX(CASE WHEN RowNum = 9 THEN units
			ELSE NULL END) AS feat9_units,
		MAX(CASE WHEN RowNum = 9 THEN ppu
			ELSE NULL END) AS feat9_ppu,
		MAX(CASE WHEN RowNum = 9 THEN actual_yr_built
			ELSE NULL END) AS feat9_yr_built,
		MAX(CASE WHEN RowNum = 9 THEN deprec_val
			ELSE NULL END) AS feat9_deprec_val,
		MAX(CASE WHEN RowNum = 10 THEN descr
			ELSE NULL END) AS feat10,
		MAX(CASE WHEN RowNum = 10 THEN grade
			ELSE NULL END) AS feat10_grade,
		MAX(CASE WHEN RowNum = 10 THEN units
			ELSE NULL END) AS feat10_units,
		MAX(CASE WHEN RowNum = 10 THEN ppu
			ELSE NULL END) AS feat10_ppu,
		MAX(CASE WHEN RowNum = 10 THEN actual_yr_built
			ELSE NULL END) AS feat10_yr_built,
		MAX(CASE WHEN RowNum = 10 THEN deprec_val
			ELSE NULL END) AS feat10_deprec_val,
		MAX(CASE WHEN RowNum = 11 THEN descr
			ELSE NULL END) AS feat11,
		MAX(CASE WHEN RowNum = 11 THEN grade
			ELSE NULL END) AS feat11_grade,
		MAX(CASE WHEN RowNum = 11 THEN units
			ELSE NULL END) AS feat11_units,
		MAX(CASE WHEN RowNum = 11 THEN ppu
			ELSE NULL END) AS feat11_ppu,
		MAX(CASE WHEN RowNum = 11 THEN actual_yr_built
			ELSE NULL END) AS feat11_yr_built,
		MAX(CASE WHEN RowNum = 11 THEN deprec_val
			ELSE NULL END) AS feat11_deprec_val,
		MAX(CASE WHEN RowNum = 12 THEN descr
			ELSE NULL END) AS feat12,
		MAX(CASE WHEN RowNum = 12 THEN grade
			ELSE NULL END) AS feat12_grade,
		MAX(CASE WHEN RowNum = 12 THEN units
			ELSE NULL END) AS feat12_units,
		MAX(CASE WHEN RowNum = 12 THEN ppu
			ELSE NULL END) AS feat12_ppu,
		MAX(CASE WHEN RowNum = 12 THEN actual_yr_built
			ELSE NULL END) AS feat12_yr_built,
		MAX(CASE WHEN RowNum = 12 THEN deprec_val
			ELSE NULL END) AS feat12_deprec_val,
		MAX(CASE WHEN RowNum = 13 THEN descr
			ELSE NULL END) AS feat13,
		MAX(CASE WHEN RowNum = 13 THEN grade
			ELSE NULL END) AS feat13_grade,
		MAX(CASE WHEN RowNum = 13 THEN units
			ELSE NULL END) AS feat13_units,
		MAX(CASE WHEN RowNum = 13 THEN ppu
			ELSE NULL END) AS feat13_ppu,
		MAX(CASE WHEN RowNum = 13 THEN actual_yr_built
			ELSE NULL END) AS feat13_yr_built,
		MAX(CASE WHEN RowNum = 13 THEN deprec_val
			ELSE NULL END) AS feat13_deprec_val,
		MAX(CASE WHEN RowNum = 14 THEN descr
			ELSE NULL END) AS feat14,
		MAX(CASE WHEN RowNum = 14 THEN grade
			ELSE NULL END) AS feat14_grade,
		MAX(CASE WHEN RowNum = 14 THEN units
			ELSE NULL END) AS feat14_units,
		MAX(CASE WHEN RowNum = 14 THEN ppu
			ELSE NULL END) AS feat14_ppu,
		MAX(CASE WHEN RowNum = 14 THEN actual_yr_built
			ELSE NULL END) AS feat14_yr_built,
		MAX(CASE WHEN RowNum = 14 THEN deprec_val
			ELSE NULL END) AS feat14_deprec_val,
		MAX(CASE WHEN RowNum = 15 THEN descr
			ELSE NULL END) AS feat15,
		MAX(CASE WHEN RowNum = 15 THEN grade
			ELSE NULL END) AS feat15_grade,
		MAX(CASE WHEN RowNum = 15 THEN units
			ELSE NULL END) AS feat15_units,
		MAX(CASE WHEN RowNum = 15 THEN ppu
			ELSE NULL END) AS feat15_ppu,
		MAX(CASE WHEN RowNum = 15 THEN actual_yr_built
			ELSE NULL END) AS feat15_yr_built,
		MAX(CASE WHEN RowNum = 15 THEN deprec_val
			ELSE NULL END) AS feat15_deprec_val,
		MAX(CASE WHEN RowNum = 16 THEN descr
			ELSE NULL END) AS feat16,
		MAX(CASE WHEN RowNum = 16 THEN grade
			ELSE NULL END) AS feat16_grade,
		MAX(CASE WHEN RowNum = 16 THEN units
			ELSE NULL END) AS feat16_units,
		MAX(CASE WHEN RowNum = 16 THEN ppu
			ELSE NULL END) AS feat16_ppu,
		MAX(CASE WHEN RowNum = 16 THEN actual_yr_built
			ELSE NULL END) AS feat16_yr_built,
		MAX(CASE WHEN RowNum = 16 THEN deprec_val
			ELSE NULL END) AS feat16_deprec_val,
		MAX(CASE WHEN RowNum = 17 THEN descr
			ELSE NULL END) AS feat17,
		MAX(CASE WHEN RowNum = 17 THEN grade
			ELSE NULL END) AS feat17_grade,
		MAX(CASE WHEN RowNum = 17 THEN units
			ELSE NULL END) AS feat17_units,
		MAX(CASE WHEN RowNum = 17 THEN ppu
			ELSE NULL END) AS feat17_ppu,
		MAX(CASE WHEN RowNum = 17 THEN actual_yr_built
			ELSE NULL END) AS feat17_yr_built,
		MAX(CASE WHEN RowNum = 17 THEN deprec_val
			ELSE NULL END) AS feat17_deprec_val,
		MAX(CASE WHEN RowNum = 18 THEN descr
			ELSE NULL END) AS feat18,
		MAX(CASE WHEN RowNum = 18 THEN grade
			ELSE NULL END) AS feat18_grade,
		MAX(CASE WHEN RowNum = 18 THEN units
			ELSE NULL END) AS feat18_units,
		MAX(CASE WHEN RowNum = 18 THEN ppu
			ELSE NULL END) AS feat18_ppu,
		MAX(CASE WHEN RowNum = 18 THEN actual_yr_built
			ELSE NULL END) AS feat18_yr_built,
		MAX(CASE WHEN RowNum = 18 THEN deprec_val
			ELSE NULL END) AS feat18_deprec_val,
		MAX(CASE WHEN RowNum = 19 THEN descr
			ELSE NULL END) AS feat19,
		MAX(CASE WHEN RowNum = 19 THEN grade
			ELSE NULL END) AS feat19_grade,
		MAX(CASE WHEN RowNum = 19 THEN units
			ELSE NULL END) AS feat19_units,
		MAX(CASE WHEN RowNum = 19 THEN ppu
			ELSE NULL END) AS feat19_ppu,
		MAX(CASE WHEN RowNum = 19 THEN actual_yr_built
			ELSE NULL END) AS feat19_yr_built,
		MAX(CASE WHEN RowNum = 19 THEN deprec_val
			ELSE NULL END) AS feat19_deprec_val,
		MAX(CASE WHEN RowNum = 20 THEN descr
			ELSE NULL END) AS feat20,
		MAX(CASE WHEN RowNum = 20 THEN grade
			ELSE NULL END) AS feat20_grade,
		MAX(CASE WHEN RowNum = 20 THEN units
			ELSE NULL END) AS feat20_units,
		MAX(CASE WHEN RowNum = 20 THEN ppu
			ELSE NULL END) AS feat20_ppu,
		MAX(CASE WHEN RowNum = 20 THEN actual_yr_built
			ELSE NULL END) AS feat20_yr_built,
		MAX(CASE WHEN RowNum = 20 THEN deprec_val
			ELSE NULL END) AS feat20_deprec_val,
		MAX(CASE WHEN RowNum = 21 THEN descr
			ELSE NULL END) AS feat21,
		MAX(CASE WHEN RowNum = 21 THEN grade
			ELSE NULL END) AS feat21_grade,
		MAX(CASE WHEN RowNum = 21 THEN units
			ELSE NULL END) AS feat21_units,
		MAX(CASE WHEN RowNum = 21 THEN ppu
			ELSE NULL END) AS feat21_ppu,
		MAX(CASE WHEN RowNum = 21 THEN actual_yr_built
			ELSE NULL END) AS feat21_yr_built,
		MAX(CASE WHEN RowNum = 21 THEN deprec_val
			ELSE NULL END) AS feat21_deprec_val,
		MAX(CASE WHEN RowNum = 22 THEN descr
			ELSE NULL END) AS feat22,
		MAX(CASE WHEN RowNum = 22 THEN grade
			ELSE NULL END) AS feat22_grade,
		MAX(CASE WHEN RowNum = 22 THEN units
			ELSE NULL END) AS feat22_units,
		MAX(CASE WHEN RowNum = 22 THEN ppu
			ELSE NULL END) AS feat22_ppu,
		MAX(CASE WHEN RowNum = 22 THEN actual_yr_built
			ELSE NULL END) AS feat22_yr_built,
		MAX(CASE WHEN RowNum = 22 THEN deprec_val
			ELSE NULL END) AS feat22_deprec_val,
		MAX(CASE WHEN RowNum = 23 THEN descr
			ELSE NULL END) AS feat23,
		MAX(CASE WHEN RowNum = 23 THEN grade
			ELSE NULL END) AS feat23_grade,
		MAX(CASE WHEN RowNum = 23 THEN units
			ELSE NULL END) AS feat23_units,
		MAX(CASE WHEN RowNum = 23 THEN ppu
			ELSE NULL END) AS feat23_ppu,
		MAX(CASE WHEN RowNum = 23 THEN actual_yr_built
			ELSE NULL END) AS feat23_yr_built,
		MAX(CASE WHEN RowNum = 23 THEN deprec_val
			ELSE NULL END) AS feat23_deprec_val
FROM
(SELECT RE, building, descr, grade, units, ppu, actual_yr_built, deprec_val,
		ROW_NUMBER() OVER (PARTITION BY RE, building) AS RowNum
FROM Feature)
GROUP BY RE, building)
USING (RE, building)
/* Subarea table query */
LEFT JOIN
(SELECT RE, building,
		MAX(CASE WHEN RowNum = 1 THEN sub_structure_descr
			ELSE NULL END) AS sub1,
		MAX(CASE WHEN RowNum = 1 THEN actual_area
			ELSE NULL END) AS sub1_actualarea,
		MAX(CASE WHEN RowNum = 1 THEN effec_area
			ELSE NULL END) AS sub1_effecarea,
		MAX(CASE WHEN RowNum = 1 THEN heated_area
			ELSE NULL END) AS sub1_heatedarea,
		MAX(CASE WHEN RowNum = 2 THEN sub_structure_descr
			ELSE NULL END) AS sub2,
		MAX(CASE WHEN RowNum = 2 THEN actual_area
			ELSE NULL END) AS sub2_actualarea,
		MAX(CASE WHEN RowNum = 2 THEN effec_area
			ELSE NULL END) AS sub2_effecarea,
		MAX(CASE WHEN RowNum = 2 THEN heated_area
			ELSE NULL END) AS sub2_heatedarea,
		MAX(CASE WHEN RowNum = 3 THEN sub_structure_descr
			ELSE NULL END) AS sub3,
		MAX(CASE WHEN RowNum = 3 THEN actual_area
			ELSE NULL END) AS sub3_actualarea,
		MAX(CASE WHEN RowNum = 3 THEN effec_area
			ELSE NULL END) AS sub3_effecarea,
		MAX(CASE WHEN RowNum = 3 THEN heated_area
			ELSE NULL END) AS sub3_heatedarea,
		MAX(CASE WHEN RowNum = 4 THEN sub_structure_descr
			ELSE NULL END) AS sub4,
		MAX(CASE WHEN RowNum = 4 THEN actual_area
			ELSE NULL END) AS sub4_actualarea,
		MAX(CASE WHEN RowNum = 4 THEN effec_area
			ELSE NULL END) AS sub4_effecarea,
		MAX(CASE WHEN RowNum = 4 THEN heated_area
			ELSE NULL END) AS sub4_heatedarea,
		MAX(CASE WHEN RowNum = 5 THEN sub_structure_descr
			ELSE NULL END) AS sub5,
		MAX(CASE WHEN RowNum = 5 THEN actual_area
			ELSE NULL END) AS sub5_actualarea,
		MAX(CASE WHEN RowNum = 5 THEN effec_area
			ELSE NULL END) AS sub5_effecarea,
		MAX(CASE WHEN RowNum = 5 THEN heated_area
			ELSE NULL END) AS sub5_heatedarea,
		MAX(CASE WHEN RowNum = 6 THEN sub_structure_descr
			ELSE NULL END) AS sub6,
		MAX(CASE WHEN RowNum = 6 THEN actual_area
			ELSE NULL END) AS sub6_actualarea,
		MAX(CASE WHEN RowNum = 6 THEN effec_area
			ELSE NULL END) AS sub6_effecarea,
		MAX(CASE WHEN RowNum = 6 THEN heated_area
			ELSE NULL END) AS sub6_heatedarea,
		MAX(CASE WHEN RowNum = 7 THEN sub_structure_descr
			ELSE NULL END) AS sub7,
		MAX(CASE WHEN RowNum = 7 THEN actual_area
			ELSE NULL END) AS sub7_actualarea,
		MAX(CASE WHEN RowNum = 7 THEN effec_area
			ELSE NULL END) AS sub7_effecarea,
		MAX(CASE WHEN RowNum = 7 THEN heated_area
			ELSE NULL END) AS sub7_heatedarea,
		MAX(CASE WHEN RowNum = 8 THEN sub_structure_descr
			ELSE NULL END) AS sub8,
		MAX(CASE WHEN RowNum = 8 THEN actual_area
			ELSE NULL END) AS sub8_actualarea,
		MAX(CASE WHEN RowNum = 8 THEN effec_area
			ELSE NULL END) AS sub8_effecarea,
		MAX(CASE WHEN RowNum = 8 THEN heated_area
			ELSE NULL END) AS sub8_heatedarea,
		MAX(CASE WHEN RowNum = 9 THEN sub_structure_descr
			ELSE NULL END) AS sub9,
		MAX(CASE WHEN RowNum = 9 THEN actual_area
			ELSE NULL END) AS sub9_actualarea,
		MAX(CASE WHEN RowNum = 9 THEN effec_area
			ELSE NULL END) AS sub9_effecarea,
		MAX(CASE WHEN RowNum = 9 THEN heated_area
			ELSE NULL END) AS sub9_heatedarea,
		MAX(CASE WHEN RowNum = 10 THEN sub_structure_descr
			ELSE NULL END) AS sub10,
		MAX(CASE WHEN RowNum = 10 THEN actual_area
			ELSE NULL END) AS sub10_actualarea,
		MAX(CASE WHEN RowNum = 10 THEN effec_area
			ELSE NULL END) AS sub10_effecarea,
		MAX(CASE WHEN RowNum = 10 THEN heated_area
			ELSE NULL END) AS sub10_heatedarea,
		MAX(CASE WHEN RowNum = 11 THEN sub_structure_descr
			ELSE NULL END) AS sub11,
		MAX(CASE WHEN RowNum = 11 THEN actual_area
			ELSE NULL END) AS sub11_actualarea,
		MAX(CASE WHEN RowNum = 11 THEN effec_area
			ELSE NULL END) AS sub11_effecarea,
		MAX(CASE WHEN RowNum = 11 THEN heated_area
			ELSE NULL END) AS sub11_heatedarea,
		MAX(CASE WHEN RowNum = 12 THEN sub_structure_descr
			ELSE NULL END) AS sub12,
		MAX(CASE WHEN RowNum = 12 THEN actual_area
			ELSE NULL END) AS sub12_actualarea,
		MAX(CASE WHEN RowNum = 12 THEN effec_area
			ELSE NULL END) AS sub12_effecarea,
		MAX(CASE WHEN RowNum = 12 THEN heated_area
			ELSE NULL END) AS sub12_heatedarea,
		MAX(CASE WHEN RowNum = 13 THEN sub_structure_descr
			ELSE NULL END) AS sub13,
		MAX(CASE WHEN RowNum = 13 THEN actual_area
			ELSE NULL END) AS sub13_actualarea,
		MAX(CASE WHEN RowNum = 13 THEN effec_area
			ELSE NULL END) AS sub13_effecarea,
		MAX(CASE WHEN RowNum = 13 THEN heated_area
			ELSE NULL END) AS sub13_heatedarea,
		MAX(CASE WHEN RowNum = 14 THEN sub_structure_descr
			ELSE NULL END) AS sub14,
		MAX(CASE WHEN RowNum = 14 THEN actual_area
			ELSE NULL END) AS sub14_actualarea,
		MAX(CASE WHEN RowNum = 14 THEN effec_area
			ELSE NULL END) AS sub14_effecarea,
		MAX(CASE WHEN RowNum = 14 THEN heated_area
			ELSE NULL END) AS sub14_heatedarea,
		MAX(CASE WHEN RowNum = 15 THEN sub_structure_descr
			ELSE NULL END) AS sub15,
		MAX(CASE WHEN RowNum = 15 THEN actual_area
			ELSE NULL END) AS sub15_actualarea,
		MAX(CASE WHEN RowNum = 15 THEN effec_area
			ELSE NULL END) AS sub15_effecarea,
		MAX(CASE WHEN RowNum = 15 THEN heated_area
			ELSE NULL END) AS sub15_heatedarea,
		MAX(CASE WHEN RowNum = 16 THEN sub_structure_descr
			ELSE NULL END) AS sub16,
		MAX(CASE WHEN RowNum = 16 THEN actual_area
			ELSE NULL END) AS sub16_actualarea,
		MAX(CASE WHEN RowNum = 16 THEN effec_area
			ELSE NULL END) AS sub16_effecarea,
		MAX(CASE WHEN RowNum = 16 THEN heated_area
			ELSE NULL END) AS sub16_heatedarea,
		MAX(CASE WHEN RowNum = 17 THEN sub_structure_descr
			ELSE NULL END) AS sub17,
		MAX(CASE WHEN RowNum = 17 THEN actual_area
			ELSE NULL END) AS sub17_actualarea,
		MAX(CASE WHEN RowNum = 17 THEN effec_area
			ELSE NULL END) AS sub17_effecarea,
		MAX(CASE WHEN RowNum = 17 THEN heated_area
			ELSE NULL END) AS sub17_heatedarea,
		MAX(CASE WHEN RowNum = 18 THEN sub_structure_descr
			ELSE NULL END) AS sub18,
		MAX(CASE WHEN RowNum = 18 THEN actual_area
			ELSE NULL END) AS sub18_actualarea,
		MAX(CASE WHEN RowNum = 18 THEN effec_area
			ELSE NULL END) AS sub18_effecarea,
		MAX(CASE WHEN RowNum = 18 THEN heated_area
			ELSE NULL END) AS sub18_heatedarea,
		MAX(CASE WHEN RowNum = 19 THEN sub_structure_descr
			ELSE NULL END) AS sub19,
		MAX(CASE WHEN RowNum = 19 THEN actual_area
			ELSE NULL END) AS sub19_actualarea,
		MAX(CASE WHEN RowNum = 19 THEN effec_area
			ELSE NULL END) AS sub19_effecarea,
		MAX(CASE WHEN RowNum = 19 THEN heated_area
			ELSE NULL END) AS sub19_heatedarea,
		MAX(CASE WHEN RowNum = 20 THEN sub_structure_descr
			ELSE NULL END) AS sub20,
		MAX(CASE WHEN RowNum = 20 THEN actual_area
			ELSE NULL END) AS sub20_actualarea,
		MAX(CASE WHEN RowNum = 20 THEN effec_area
			ELSE NULL END) AS sub20_effecarea,
		MAX(CASE WHEN RowNum = 20 THEN heated_area
			ELSE NULL END) AS sub20_heatedarea,
		MAX(CASE WHEN RowNum = 21 THEN sub_structure_descr
			ELSE NULL END) AS sub21,
		MAX(CASE WHEN RowNum = 21 THEN actual_area
			ELSE NULL END) AS sub21_actualarea,
		MAX(CASE WHEN RowNum = 21 THEN effec_area
			ELSE NULL END) AS sub21_effecarea,
		MAX(CASE WHEN RowNum = 21 THEN heated_area
			ELSE NULL END) AS sub21_heatedarea
FROM
(SELECT  RE, building, 
		ROW_NUMBER() OVER (PARTITION BY RE, building) AS RowNum,
		sub_structure_descr, actual_area, effec_area, heated_area
FROM Subarea)
GROUP BY RE, building) AS subarea_query
USING (RE, building)
)
/* Single-family properties and qualified sales */
WHERE property_use = 100 AND ((status = 'Qualified' AND improved = 'I') OR status = 'NONE')