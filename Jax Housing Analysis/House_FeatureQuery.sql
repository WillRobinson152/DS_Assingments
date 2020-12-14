SELECT  substr(Parcel.RE,1,6)||' '||substr(Parcel.RE,7,4) AS RE, building,
		ft_descr, features, avg_grade, total_deprec_value, total_ft_price, avg_ft_price, avg_ft_age		
FROM Parcel
LEFT JOIN Building USING (RE)
LEFT JOIN 
(SELECT RE, building, ft_descr, features, avg_grade, total_deprec_value, total_ft_price, avg_ft_price, avg_ft_age
FROM Feature
LEFT JOIN 
(SELECT RE, building, COUNT(*) AS features, ROUND(AVG(grade),1) AS avg_grade, SUM(deprec_value) AS total_deprec_value, CAST(SUM(units)*SUM(ppu) AS INT) AS total_ft_price, 
		ROUND(SUM(units)*SUM(ppu)/COUNT(*),1) AS avg_ft_price, ROUND(2020 - AVG(actual_yr_built),1) AS avg_ft_age 
FROM Feature
WHERE actual_yr_built > 0 
GROUP BY RE, building) USING (RE, building)
WHERE actual_yr_built > 0) USING (RE, building)
WHERE property_use='0100' AND type_descr LIKE '%SFR%'