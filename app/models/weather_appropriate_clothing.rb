class WeatherAppropriateClothing
  attr_reader :gender, :items

  @@body_parts = Wearable.get_body_parts

  def initialize(config)
    @gender = config[:gender]
    @items = get_appropriate_clothing(config[:weather])
  end

  private
    def get_appropriate_clothing(weather)
      clothes = @@body_parts.reduce({}) do |a, e|
        appropriate_clothes = Wearable.get_appropriate_clothing(e, { gender: "M" }, weather.temperature)
        a[e] = appropriate_clothes unless appropriate_clothes.empty?
        a
      end
    end
end