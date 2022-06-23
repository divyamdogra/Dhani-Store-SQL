SELECT a.product_id,a.sap_code,a.name,SUM(a.quantity) FROM epharmacy.order_items a
WHERE
a.created_time BETWEEN '2022-05-10 00:00:00' AND '2022-05-10 23:59:59'
AND
a.sap_code <> '10171041873'
AND 
a.sap_code is NOT NULL
GROUP BY  a.product_id,a.sap_code,a.name
ORDER BY SUM(a.quantity) DESC;




SELECT * FROM category a
JOIN category_product_map b 
ON a.id = b.category_id
WHERE b.product_id = '282757';
