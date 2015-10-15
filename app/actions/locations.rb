helpers do
  def get_clothing
    body_parts = Wearables.get_body_parts

    clothes = body_parts.reduce({}) do |a, e|
      a[e] = Wearables.get_appropriate_clothing(e, { gender: "M" }, @weather)
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