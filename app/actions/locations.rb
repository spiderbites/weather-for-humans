require 'json'
require 'date'

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

  def generator(time, temperature)
      {
        time: time,
        temperature: temperature,
        clothes: yield
      }
  end
end

get '/location/:city_country/data' do
  content_type :json
  @weather = Weather.new(params)
  forecast = @weather.get_three_day_forecast
  forecast.to_json
end

get '/location/:city_country' do
  @city_country = params[:city_country]
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
  @temperature = { today: [1,2,3,4], tomorrow: [1,5,7,8] }.to_json

  erb :kevin
end

get '/experiment_robynn' do
  @weather = Weather.new({city_country: 'Bogota'})
  # puts Wearable.need_extras(@weather.condition).inspect
  # puts get_extras
  ""
end







get '/data' do
  content_type :json

  days = %w[Monday Tuesday Wednesday]
  times = [8, 11, 14, 17, 20, 23]
  temperatures = [10, 13, 12, 15, 17, 24, 9, 30]
  all_clothes = Wearable.distinct.select(:clothing).map(&:clothing)

  cycles = days.map do |day|

    time_temp = times.map do |time|
      [time, temperatures.sample]
    end

    cycle = time_temp.map do |time, temperature|
      generator(time, temperature) { all_clothes.sample(5) }
    end

    {
      day: day,
      cycle: cycle
    }
  end
  cycles.to_json
end