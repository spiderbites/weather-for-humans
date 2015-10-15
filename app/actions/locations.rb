helpers do
  def get_clothing
    body_parts = Wearable.get_body_parts

    clothes = body_parts.reduce({}) do |a, e|
      a[e] = Wearable.get_appropriate_clothing(e, { gender: "U" }, @weather)
      a
    end
  end
end

get '/location' do
  @weather = Weather.new(params)
  @clothes = get_clothing

  erb :location
end

post '/location' do
  @weather = Weather.new(params)
  @clothes = get_clothing

  erb :location
end