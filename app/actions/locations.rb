require 'json'

helpers do
  def obtain_all_clothes(config)
    DiurnalCycles.initialize(config)
    all_clothes = DiurnalCycles.cycles.map do |cycle|
      cycle.cycle.map do |weather|
        WeatherAppropriateClothing.new(weather, { gender: 'M' })
      end
    end
  end

  def obtain_main_clothes(all_clothes)
    all_clothes.map { |sets| sets[0] } #of beginning of today, tomorrow etc.
  end

  def filter_extra_clothing(all_clothes)
    all_clothes.map do |various_sets_in_one_day|
      WeatherAppropriateClothing.determine_extras_from_sets_clothings(various_sets_in_one_day.map { |e| e.items })
    end
  end
end

get '/location/:city_country/data' do
  content_type :json

  all_clothes = obtain_all_clothes(params.merge(duration: 4))
  extra = filter_extra_clothing(all_clothes)
  main_clothes = obtain_main_clothes(all_clothes)

  # pair up the two arrays and convert into array of hashes.
  (main_clothes.zip(extra)).map do |day_set_clothes|
    {main: day_set_clothes[0].items.values, extra: day_set_clothes[1].values.flatten}
  end.to_json
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