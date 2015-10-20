wearables_list = [
  ['toque','head',-274,5,'U', 0],
  ['scarf','neck',-274,5,'U', 0],
  ['parka','body-layer-4',-274,5,'U', 0],
  ['light-jacket','body-layer-4',6,10,'U', 0],
  ['sweater','body-layer-3',11,16,'U', 0],
  ['longsleeve-shirt','body-layer-2',17,21,'U', 0],
  ['t-shirt','body-layer-1',22,1000,'U', 0],
  ['tank-top','body-layer-1',22,1000,'U', 0],
  ['heavy-gloves','hands',-274,3,'U', 0],
  ['light-gloves','hands',4,7,'U', 0],
  ['pants','legs',-5,21,'U', 0],
  ['shorts','legs',22,1000,'U', 0],
  ['winter-boots','feet',-274,5,'U', 0],
  ['shoes','feet',6,24,'U', 0],
  ['sandals','feet',25,1000,'U', 0],
  ['sunglasses','eyes',nil,nil,'U','800'],
  ['umbrella','overhead',nil,nil,'U', '400'],
  ['rainboots','feet',6,24,'U', '400'],
  ['raincoat','body-layer-4',6,10,'U','400']
]

wearables_list.each do |clothing, body_part, min_temp, max_temp, gender, conditions|
  Wearable.create(
    clothing: clothing,
    body_part: body_part,
    min_temp: min_temp,
    max_temp: max_temp,
    gender: gender,
    conditions: conditions
  )
end