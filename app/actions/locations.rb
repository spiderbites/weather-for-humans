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
      appropriate_extras = Wearable.need_extras(e, @weather.condition)
      a[e] = appropriate_extras unless appropriate_extras.empty?
      a
    end
    all_items = clothes.merge(extras)
  end
end

get '/location/:city_country' do
  @forecast = Forecast.new(params, 0) # only get current temp for now
  @weather = @forecast.forecast[0] #Weather.new(params)
  @clothes = get_clothing
  erb :location
end

get '/location' do
  @forecast = Forecast.new(params, 0) # only get current temp for now
  @weather = @forecast.forecast[0] #Weather.new(params)
  @clothes = get_clothing
  erb :location
end

post '/location' do
  redirect "location/#{params[:city_country]}"
end