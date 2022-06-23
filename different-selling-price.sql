#Last 7 days product orders with different selling price because of the sale prices everyday changes

SELECT DATE(b.created_time),b.product_id,b.sap_code,b.name,b.is_mp_product,b.selling_price AS sale_price,
count(DISTINCT a.order_uuid) AS orders_count, SUM(b.quantity)
FROM epharmacy.orders a
JOIN epharmacy.order_items b
ON a.id=b.order_id
JOIN epharmacy.payment c
ON a.id=c.order_id
WHERE
date(a.created_time) >=  DATE(NOW()) - interval 7 DAY
#AND
#date(a.created_time) < DATE(NOW())
AND
c.`status` = 'success'
AND
b.sap_code = 'AMISTSB225ERPHNBLK01'
group BY DATE(b.created_time),b.product_id,b.sap_code,b.name,b.is_mp_product,sale_price
ORDER BY COUNT(DISTINCT a.order_uuid) DESC;