#On Store KBM google sheet to be updated by before 9:30am daily


SELECT * FROM
(
select aa.id AS category_id,aa.cat_url,bb.product_id from
(
SELECT l0.id,
 CONCAT(
 case when l5.id is null then '' else CONCAT(l6.name, '~') end ,
 case when l5.id is null then '' else concat(l5.name, '~') end ,
 case when l4.id is null then '' else concat(l4.name, '~') END ,
 case when l3.id is null then '' else concat(l3.name, '~') end ,
 case when l2.id is null then '' else concat(l2.name, '~') end ,
 case when l1.id is null then '' else concat(l1.name, '~') end ,
 l0.name) AS cat_url
 from epharmacy.category l0
 left join epharmacy.category l1 on l0.parent_id=l1.id
 LEFT join epharmacy.category l2 on l1.parent_id=l2.id
 left join epharmacy.category l3 on l2.parent_id=l3.id
 left join epharmacy.category l4 on l3.parent_id=l4.id
 left join epharmacy.category l5 on l4.parent_id=l5.id
 left join epharmacy.category l6 ON l5.parent_id=l6.id
 where
 l0.`status` = 'active'
 )aa
Join
(#Product -> cat map
SELECT a.product_id,MAX(a.category_id) AS cat_id FROM epharmacy.category_product_map a
WHERE
a.is_active=1
GROUP BY a.product_id
)bb
ON aa.id=bb.cat_id
)cc
JOIN
(
SELECT DATE(a.created_time) AS DATE,a.product_id,name,sum(a.quantity) AS item_sold,SUM(a.selling_price) AS revenue FROM epharmacy.order_items a
JOIN epharmacy.orders b
ON a.order_id=b.id
JOIN epharmacy.payment c
ON b.id=c.order_id
WHERE
DATE(a.created_time) >= DATE(NOW()) - interval 2 DAY
AND
DATE(a.created_time) < DATE(NOW())
AND
c.`status` = 'success'
AND
a.sap_code <> '10171041873'
GROUP BY DATE(a.created_time), a.product_id
)dd
ON cc.product_id=dd.product_id;





#Payment Success (orders and GMV row 20,21 of store kbm)
SELECT date(a.created_time),COUNT(a.order_id),sum(a.paid_price) FROM epharmacy.payment a
WHERE
a.`status`='success'
AND
date(a.created_time) >= '2022-04-01'
AND
date(a.created_time) < DATE(NOW())
GROUP BY  date(a.created_time)
ORDER BY date(a.created_time) DESC;








# PAY DAY SAlE issue--- if category is not active then this way you can see that
SELECT * FROM
(
select aa.id AS category_id,aa.cat_url,bb.product_id from
(
SELECT l0.id,
 CONCAT(
 case when l5.id is null then '' else CONCAT(l6.name, '~') end ,
 case when l5.id is null then '' else concat(l5.name, '~') end ,
 case when l4.id is null then '' else concat(l4.name, '~') end ,
 case when l3.id is null then '' else concat(l3.name, '~') end ,
 case when l2.id is null then '' else concat(l2.name, '~') end ,
 case when l1.id is null then '' else concat(l1.name, '~') end ,
 l0.name) AS cat_url
 from epharmacy.category l0
 left join epharmacy.category l1 on l0.parent_id=l1.id
 LEFT join epharmacy.category l2 on l1.parent_id=l2.id
 left join epharmacy.category l3 on l2.parent_id=l3.id
 left join epharmacy.category l4 on l3.parent_id=l4.id
 left join epharmacy.category l5 on l4.parent_id=l5.id
 left join epharmacy.category l6 ON l5.parent_id=l6.id

 )aa
Join
(#Product -> cat map
SELECT a.product_id,MAX(a.category_id) AS cat_id FROM epharmacy.category_product_map a
WHERE
a.is_active=1
GROUP BY a.product_id
)bb
ON aa.id=bb.cat_id
)cc
JOIN
(
SELECT DATE(a.created_time) AS DATE,a.product_id,name,sum(a.quantity) AS item_sold,SUM(a.selling_price) AS revenue FROM epharmacy.order_items a
JOIN epharmacy.orders b
ON a.order_id=b.id
JOIN epharmacy.payment c
ON b.id=c.order_id
WHERE
DATE(a.created_time) >= DATE(NOW()) - interval 2 DAY
AND
DATE(a.created_time) < DATE(NOW())
AND
c.`status` = 'success'
AND
a.sap_code <> '10171041873'
GROUP BY DATE(a.created_time), a.product_id
)dd
ON cc.product_id=dd.product_id;