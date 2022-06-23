1.	UTM DATA

SELECT 
distinct a.id,
a.order_uuid,
a.promo_code_id,
b.promo_code,


c.first_name,
c.last_name,
c.mobile,
c.email,
a.promo_code_discount,
a.discount_percent,
a.total_mrp,
a.product_discount,
a.product_payable,

a.status,
a.refund_process,
a.delivery_fee,
d.delivery_time,
a.cancellation_time,
(a.created_time),
(a.updated_time),
a.utm_source,
a.utm_medium,
a.utm_campaign,
a.utm_content,
a.utm_id,
a.remark,
a.device_type,
a.order_type,
a.freebie_availed
FROM orders AS a
left JOIN customer AS c ON  a.customer_id = c.id 
left JOIN promo_code AS b ON a.promo_code_id = b.id 
left JOIN shipments AS d ON a.id = d.order_id 
#left JOIN epharmacy.order_items as e ON a.id = e.order_id
where
#WHERE b.promo_code IN ("HDFCEX")
#WHERE a.utm_source like ("Store Home%")
#where a.order_uuid IN ("EP3440640") and
#WHERE d.delivery_time IS NULL AND a.status = "delivered"
#e.sap_code IN ('Panda_Gold_M','Panda_Gold_L','Panda_Gold_XL','AMR_RoyalBlue_04_S','AMR_RoyalBlue_04_M','AMR_RoyalBlue_04_L','AMR_RoyalBlue_04_XL')
#and
#c.mobile = 7018262327 and
a.created_time BETWEEN '2022-05-20 00:00:00' AND '2022-05-31 23:59:59';



SELECT DISTINCT(mobile) FROM orders LIMIT 100;






#for dof table

SELECT 
distinct c.mobile,

(a.created_time)

FROM orders AS a
left JOIN customer AS c ON  a.customer_id = c.id 
left JOIN promo_code AS b ON a.promo_code_id = b.id 
left JOIN shipments AS d ON a.id = d.order_id 
left JOIN epharmacy.order_items as e ON a.id = e.order_id

#WHERE b.promo_code IN ("HDFCEX")
#WHERE a.utm_source like ("Store Home%")
#where a.order_uuid IN ("EP1417918")
#WHERE d.delivery_time IS NULL AND a.status = "delivered"
WHERE  a.created_time BETWEEN '2022-05-14 00:00:00' AND '2022-05-22 23:59:59';
