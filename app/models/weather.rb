class Weather
  attr_accessor :temperature, :weather_id, :condition_id, :time

  def initialize(config)
    @temperature = config[:temperature]
    @weather_id = config[:weather_id]
    @condition_id = config[:condition_id]
    @time = config[:time]
  end
end