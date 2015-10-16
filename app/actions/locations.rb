require 'json'

helpers do
  def get_clothing
    body_parts = Wearable.get_body_parts

    clothes = body_parts.reduce({}) do |a, e|
      appropriate_clothes = Wearable.get_appropriate_clothing(e, { gender: "M" }, @weather)
      a[e] = appropriate_clothes unless appropriate_clothes.empty?
      a
    end
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

get '/experiment_kevin' do
  @temperature = {today: [1,2,3,4], tomorrow: [1,5,7,8]}.to_json
  erb :kevin
end