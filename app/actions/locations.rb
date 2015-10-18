require 'json'

helpers do
  def get_clothing
    body_parts = Wearable.get_body_parts

    clothes = body_parts.reduce({}) do |a, e|
      appropriate_clothes = Wearable.get_appropriate_clothing(e, { gender: "M" }, @weather)
      a[e] = appropriate_clothes unless appropriate_clothes.empty?
      a
    end
    extras = body_parts.reduce({}) do |a,e|
      appropriate_extras = Wearable.need_extras(e, @weather)
      a[e] = appropriate_extras unless appropriate_extras.empty?
      a
    end
    puts @weather.condition
    puts clothes.merge!(extras)
    all_items = clothes.merge!(extras)
  end

end

get '/location/:city_country' do
  @weather = Weather.new(params)
  @clothes = get_clothing
  erb :location
end

get '/location' do
  @weather = Weather.new(params)
  @clothes = get_clothing
  erb :location
end

post '/location' do
  redirect "location/#{params[:city_country]}"
end