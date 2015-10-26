wearables_list = [
  ['toque','head',-274,5,'U', nil],
  ['scarf','neck',-274,5,'U', nil],
  ['parka','body-layer-4',-274,5,'U', nil],
  ['light-jacket','body-layer-4',6,10,'U', nil],
  ['sweater','body-layer-3',11,16,'U', nil],
  ['longsleeve-shirt','body-layer-2',17,21,'U', nil],
  ['t-shirt','body-layer-1',22,1000,'U', nil],
  ['tank-top','body-layer-1',22,1000,'U', nil],
  ['heavy-gloves','hands',-274,3,'U', nil],
  ['light-gloves','hands',4,7,'U', nil],
  ['pants','legs',-5,21,'U', nil],
  ['shorts','legs',22,1000,'U', nil],
  ['winter-boots','feet',-274,5,'U', nil],
  ['shoes','feet',6,24,'U', nil],
  ['sandals','feet',25,1000,'U', nil],
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