class WeatherAppropriateClothing
  attr_reader :config, :items

  @@body_parts = Wearable.get_body_parts

  def initialize(weather, config)
    @config = config
    @items = get_appropriate_clothing(weather)
  end

  private
    def get_appropriate_clothing(weather)
      clothes = @@body_parts.reduce([]) do |a, e|
        appropriate_clothes = Wearable.get_appropriate_clothing(e, config, weather)
        a << appropriate_clothes unless appropriate_clothes.empty?
        a
      end
    end
end