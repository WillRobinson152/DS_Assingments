SELECT substr(Parcel.RE,1,6)||' '||substr(Parcel.RE,7,4) AS RE, building, TRIM(use_descr) AS use_descr, land_uses, land_value, max_units_per_acre
FROM Parcel
LEFT JOIN Building USING (RE)
LEFT JOIN Common USING (RE)
LEFT JOIN 
(SELECT RE, COUNT(*) AS land_uses, SUM(land_val) AS land_value,
		MAX(CASE WHEN use_descr LIKE '%1 UNIT PER 100 A%' THEN 0.01
			 WHEN use_descr LIKE '%1 UNIT PER 40 A%' THEN 0.025
			 WHEN use_descr LIKE '%1 UNIT PER 10 A%' THEN 0.1
			 WHEN use_descr LIKE '%1 UNIT PER 2.5 A%' THEN 0.4
			 WHEN use_descr LIKE '%8-19 UNITS PER A%' THEN 19
			 WHEN use_descr LIKE '%3-7 UNITS PER A%' THEN 7
			 WHEN use_descr LIKE '%2 OR LESS%' THEN 2
			 WHEN use_descr LIKE '%20-60 UNITS PER A%' THEN 60
			 ELSE NULL END) AS max_units_per_acre
FROM Common
GROUP BY RE) USING (RE)
WHERE property_use = '0100' AND type_descr LIKE '%SFR%'