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

  def generator(time, temperature)
      {
        time: time,
        temperature: temperature,
        clothes: yield
      }
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

class DiurnalCycle

  attr_reader :day

  def initialize(day_of_week)
    @day = day_of_week
    @cycle = []
  end

  def add_unit(unit)
    cycle << unit
  end

  def get_unit
    cycle.pop
  end

  private
    attr_accessor :cycle
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

get '/experiment_kevin' do
  @temperature = { today: [1,2,3,4], tomorrow: [1,5,7,8] }.to_json

  erb :kevin
end