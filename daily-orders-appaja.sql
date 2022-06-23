SELECT a.mobile,a.first_name,a.last_name,a.email,b.id AS order_id, b.order_uuid,b.device_type,b.`status` AS order_status,b.utm_source,b.utm_medium,
c.sap_code,c.name,c.selling_price,c.is_mp_product,c.quantity,d.line1 AS cust_address1,d.line2 AS cust_address2, d.city,d.pincode,e.payment_method,e.`status` AS payment_status,c.product_id,c.created_time AS order_time,
f.dispatch_time,f.delivery_time,b.cancellation_time 
FROM epharmacy.customer a
JOIN epharmacy.orders b
ON a.id=b.customer_id
JOIN epharmacy.order_items c
ON b.id=c.order_id
JOIN epharmacy.address d
on b.address_id= d.id   
JOIN epharmacy.payment e
ON c.order_id=e.order_id
JOIN epharmacy.shipments f
ON c.order_id=f.order_id

WHERE
#DATE(b.created_time) >= '2022-04-15'
DATE(b.created_time) BETWEEN "2022-06-13" AND "2022-06-13"
#AND e.`status` = 'success';






SELECT * FROM epharmacy.orders LIMIT 100;
SELECT * FROM epharmacy.order_items LIMIT 100;
SELECT * FROM epharmacy.address LIMIT 100;
SELECT * FROM epharmacy.payment LIMIT 100;
SELECT * FROM epharmacy.shipments LIMIT 100;
SELECT * FROM epharmacy.category LIMIT 100;



SELECT distinct b.id AS order_id, b.order_uuid,c.created_time AS order_time,f.dispatch_time,f.delivery_time,b.cancellation_time 
FROM epharmacy.customer a
JOIN epharmacy.orders b
ON a.id=b.customer_id
JOIN epharmacy.order_items c
ON b.id=c.order_id
JOIN epharmacy.address d
on b.address_id= d.id
JOIN epharmacy.payment e
ON c.order_id=e.order_id
JOIN epharmacy.shipments f
ON c.order_id=f.order_id

WHERE
#DATE(b.created_time) >= '2022-04-15'
DATE(b.created_time) BETWEEN "2022-05-01" AND "2022-06-12"
AND
e.`status` = 'success';