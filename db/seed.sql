-- https://docs.google.com/spreadsheets/d/1nAzvSb4kvFICt_bL17VRZLXrd3QGWl4R8BTjPHnYxSI/edit?usp=sharing

INSERT INTO "wearables" (clothing, body_part, min_temp, max_temp, gender, conditions, thickness, waterproofness)
          SELECT 'toque' AS 'clothing','head' AS 'body_part',-274 AS 'min_temp', 5 AS 'max_temp','U' AS 'gender', null AS 'conditions', 50 AS 'thickness', 0 AS 'waterproofness'
UNION ALL SELECT 'scarf','neck',-274,5,'F', null, 20, 0
UNION ALL SELECT 'parka','body-layer-4',-274,5,'U', null, 70, 80
UNION ALL SELECT 'light-jacket','body-layer-4',6,10,'U', null, 50, 30
UNION ALL SELECT 'sweater','body-layer-3',11,16,'U', null, 30, 0
UNION ALL SELECT 'longsleeve-shirt','body-layer-2',17,21,'U', null, 23, 0
UNION ALL SELECT 't-shirt','body-layer-1',22,1000,'M', null, 10, 0
UNION ALL SELECT 'tank-top','body-layer-1',22,1000,'F', null, 10, 0
UNION ALL SELECT 'heavy-gloves','hands',-274,3,'U', null, 50, 0
UNION ALL SELECT 'light-gloves','hands',4,7,'U', null, 40, 0
UNION ALL SELECT 'pants','legs',-5,21,'U', null, 30, 0
UNION ALL SELECT 'shorts','legs',22,1000,'U', null, 15, 0
UNION ALL SELECT 'winter-boots','feet',-274,5,'U', null, 60, 80
UNION ALL SELECT 'shoes','feet',6,24,'U', null, 40, 40
UNION ALL SELECT 'sandals','feet',25,1000,'U', null, 15, 0
UNION ALL SELECT 'sunglasses','eyes',null, null,'U','800', null, null
UNION ALL SELECT 'umbrella','overhead',null,null,'U', '400', null, 80;