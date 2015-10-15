class Wearable < ActiveRecord::Base
  def self.get_body_parts
    Wearable.distinct.select(:body_part).map(&:body_part)
  end

  def self.get_appropriate_clothing(body_part, user_specifications, weather)
     result = Wearable.where("gender = '#{user_specifications[:gender]}' and body_part = '#{body_part}' and min_temp <= #{weather.temperature} and max_temp >= #{weather.temperature}")
     result.map { |wearable| wearable.clothing }
  end
end