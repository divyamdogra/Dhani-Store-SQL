#15 days from today maketing dump

SELECT gg.category_id,gg.cat_url,gg.product_id,gg.is_mp_product,gg.sap_code,gg.name,gg.mrp,gg.selling_price,gg.product_URL,gg.total_order,hh.inventory from
(
SELECT ee.category_id,ee.cat_url,ee.product_id,ee.is_mp_product,ee.sap_code,ee.name,ee.mrp,ee.selling_price,ee.product_URL,ff.total_order from
(
SELECT cc.category_id,cc.cat_url,cc.product_id,dd.is_mp_product,dd.sap_code,dd.name,dd.mrp,dd.selling_price,dd.product_URL from
(
select aa.id AS category_id,aa.cat_url,bb.product_id from
(
SELECT l0.id,
 CONCAT(
 case when l5.id is null then '' else CONCAT(l6.name, '~') end ,
 case when l5.id is null then '' else concat(l5.name, '~') END ,
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
SELECT a.id,a.sap_code,a.name,a.mrp,a.selling_price,a.is_mp_product,CONCAT('www.dhani.com/pharmacy-store/',a.slug) AS product_URL FROM epharmacy.product a
WHERE
a.is_active = 1
)dd
ON cc.product_id=dd.id
)ee

Left JOIN
(#orders
SELECT a.product_id,COUNT(distinct a.order_id) AS total_order FROM epharmacy.order_items a
WHERE
date(a.created_time) > DATE(NOW()) - interval 15 DAY
AND
a.sap_code <> '10171041873'
GROUP BY a.product_id
)ff
ON ee.product_id=ff.product_id
)gg

LEFT JOIN
(#product details
SELECT distinct a.id,sum(b.inventory) AS inventory FROM epharmacy.product a
JOIN epharmacy.product_inventory_stock b
ON a.id=b.product_id
WHERE
b.inventory > 0
AND
a.is_active = 1
GROUP BY a.id
)hh
ON gg.product_id=hh.id;