class WeatherAppropriateClothing
  attr_reader :config, :items

  @@body_parts = Wearable.get_body_parts

  def initialize(weather, config)
    @config = config
    @items = get_appropriate_clothing(weather)
  end

  class << self

    # Given sets of clothing, return for each body part a corresponding unique
    # set of clothing over and above the first set of clothes provided.
    # The first set of clothes represent the clothes corresponding to the
    # current weather forecast. Later entries represent a set of clothing for a
    # forecast.
    # This allows us to grant the user a small peek into the future with regards
    # to extras he may consider taking on the road.
    def determine_extras_from_sets_clothings(sets_of_clothings)
      all = sets_of_clothings
      unique_keys = all.map(&:keys).reduce(&:|)

      unique_keys.reduce({}) do |memo, body_part|
        # Given a key, use it to query the entire array of hashes and do a union
        # over all the corresponding values so that only unique values remain.
        result = all.reduce(nil) { |acc, e| !acc.nil? ? acc | [e[body_part]] : [e[body_part]] }
        # remove nil from those results as well as any value that corresponds to
        # the set of clothing of the current weather forecast
        result = result.select { |e| !e.nil? && all[0][body_part] != e }
        # if any values remain, then they represent the extra set of clothings for a
        # given body part, over and above the ones suggested for the current
        # weather cast
        memo[body_part] = result unless result.empty?
        memo
      end
    end
  end

  private
    def get_appropriate_clothing(weather)
      clothes = @@body_parts.reduce({}) do |a, e|
        appropriate_clothes = Wearable.get_appropriate_clothing(e, config, weather)
        a[e] = appropriate_clothes[0] unless appropriate_clothes.empty?
        a
      end
    end
end