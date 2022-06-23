Re: Ordered Above 499 and not cancelled
Code:- Just change Date only

SELECT DISTINCT a.mobile,a.first_name,a.email,b.order_uuid,b.`status`,b.product_payable FROM epharmacy.customer a
JOIN epharmacy.orders b
ON a.id=b.customer_id
JOIN epharmacy.payment c
ON b.id=c.order_id
WHERE
c.`status` = 'success'
AND
b.`status`  <> 'cancelled'
AND
b.product_payable >= 499 AND
b.created_time BETWEEN '2022-05-12 00:00:00' AND '2022-05-12 23:59:59';    #yyyy-mm-dd


SELECT DISTINCT(status) FROM epharmacy.orders LIMIT 1000;