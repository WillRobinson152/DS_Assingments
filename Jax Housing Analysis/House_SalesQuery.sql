SELECT substr(RE,1,6)||' '||substr(RE,7,4) AS RE, qualified_sales, avg_price, top_date, top_price, most_recent_date, most_recent_price
FROM
(SELECT RE, COUNT(*) AS qualified_sales, ROUND(AVG(price),2) AS avg_price
FROM
(
SELECT *
FROM Sale
LEFT JOIN Qualification ON qualification=q_id
WHERE status = 'Qualified' AND improved = 'I'
GROUP BY or_bk_pg)
GROUP BY RE)
LEFT JOIN
(SELECT RE, sale_date AS top_date, MAX(price) AS top_price
FROM
(
SELECT * 
FROM Sale
LEFT JOIN Qualification ON qualification=q_id
WHERE status = 'Qualified' AND improved = 'I'
GROUP BY or_bk_pg
)
GROUP BY RE)
USING (RE)
LEFT JOIN
(SELECT RE, MAX(sale_date) AS most_recent_date, price AS most_recent_price
FROM
(
SELECT * 
FROM Sale
LEFT JOIN Qualification ON qualification=q_id
WHERE status = 'Qualified' AND improved = 'I'
GROUP BY or_bk_pg
)
GROUP BY RE)
USING (RE)