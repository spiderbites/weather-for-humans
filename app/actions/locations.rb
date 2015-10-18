require 'json'

get '/location/:city_country/data' do
  content_type :json
  DiurnalCycles.initialize(params.merge(duration: 4))

  @clothes = DiurnalCycles.cycles.map do |cycle|
    cycle.cycle.map do |weather|
      WeatherAppropriateClothing.new(weather, { gender: 'M' })
    end
  end
  @clothes.to_json
end

get '/location/:city_country' do
  @city_country = params[:city_country]
  erb :location
end

get '/location' do
  @weather = ForecastWeather.new(params)
  erb :location
end

post '/location' do
  redirect "location/#{params[:city_country]}"
end

get '/kevin' do
  DiurnalCycles.initialize({ city_country: 'Moscow,Russia',
                             duration: 3 })
  @clothes = DiurnalCycles.cycles.map do |cycle|
    cycle.cycle.map do |weather|
      WeatherAppropriateClothing.new({ gender: 'M', weather: weather })
    end
  end
  erb :kevin
end