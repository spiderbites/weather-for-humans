class Wearables < ActiveRecord::Base
  def self.get_body_parts
    Wearables.distinct.select(:body_part).map(&:body_part)
  end

  def self.get_appropriate_clothing(body_part, user_specifications, weather)
     result = Wearables.where("gender = '#{user_specifications[:gender]}' and body_part = '#{body_part}' and min_temp <= #{weather.temperature} and max_temp >= #{weather.temperature}")
     result.map { |wearable| wearable.clothing }
  end
end