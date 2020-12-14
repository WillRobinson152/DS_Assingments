SELECT  substr(Parcel.RE,1,6)||' '||substr(Parcel.RE,7,4) AS RE, building, substructure_descr, substructures, total_sub_area, total_sub_effec_area, total_sub_heated_area, avg_sub_effec_area 
FROM Parcel
LEFT JOIN Building USING (RE)
LEFT JOIN Subarea USING (RE, building)
LEFT JOIN
(SELECT  RE, building, COUNT(*) AS substructures, SUM(actual_area) AS total_sub_area, SUM(effec_area) AS total_sub_effec_area, SUM(heated_sf) AS total_sub_heated_area, 
		ROUND(AVG(effec_area),1) AS avg_sub_effec_area
FROM Subarea
WHERE substructure_descr <> 'Base Area'
GROUP BY RE, building) USING (RE, building)
WHERE property_use='0100' AND type_descr LIKE '%SFR%' AND substructure_descr <> 'Base Area'