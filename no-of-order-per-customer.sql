# to check the number of orders on mobile number for specific sap code 

SELECT DISTINCT a.mobile,COUNT(distinct b.order_uuid),count(distinct c.sap_code), sum(c.quantity) AS quantity,SUM(c.selling_price) AS sp#,date(b.created_time) 
FROM epharmacy.customer a
JOIN epharmacy.orders b
ON a.id = b.customer_id
JOIN epharmacy.order_items c
ON b.id = c.order_id
JOIN payment p ON b.id = p.order_id 
#WHERE c.sap_code IN ('10170873832')
#AND
where c.created_time BETWEEN '2022-05-27 00:00:00' AND '2022-05-27 23:59:59'
AND p.`status`='success'
GROUP BY a.mobile#,date(b.created_time)
ORDER BY quantity  DESC;     #,COUNT(distinct b.order_uuid)




# to check city, payment-method ,pincode ,customer and order id

SELECT DATE(o.created_time),o.device_type,j.city,p.payment_method,j.pincode,COUNT(DISTINCT o.customer_id) as customers,COUNT(DISTINCT o.order_uuid) AS orders1 
FROM orders as o
LEFT join address j ON j.id = o.address_id
LEFT JOIN payment p ON p.order_id = o.id
WHERE(o.created_time BETWEEN '2022-05-24 00:00:00' AND '2022-05-24 23:59:59')
GROUP BY DATE(o.created_time),o.device_type,j.city,p.payment_method
ORDER BY orders1 DESC;


# to check order of customer with mobile_number from 1st query above to check fraud cases

SELECT distinct b.order_uuid,a.mobile,a.first_name,a.last_name,a.email,b.id AS order_id,b.created_time,j.city,p.payment_method,p.`status`,j.pincode,b.device_type,b.`status` AS order_status,c.sap_code,c.name,b.product_payable,c.selling_price,c.is_mp_product,c.quantity 
FROM epharmacy.customer a
JOIN epharmacy.orders b
ON a.id = b.customer_id
JOIN epharmacy.order_items c
ON b.id = c.order_id
JOIN payment p ON b.id = p.order_id 
join address j ON j.id = b.address_id
#WHERE c.sap_code IN ('10170873832')
#AND
where c.created_time BETWEEN '2022-05-27 00:00:00' AND '2022-05-27 23:59:59'
#AND a.mobile IN ('9653477771','8697524619','9041984780','9593809024','7009159047','8871025800','8755117964')

AND a.mobile IN ('9642181650')
#AND b.customer_id ='5797003'
AND p.`status`='success'