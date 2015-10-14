class Wearables < ActiveRecord::Base
  def self.get_body_parts
    Wearables.distinct.select(:body_part).map(&:body_part)
  end

  def self.get_appropriate_clothing(body_part, user_specifications, weather_data)
    Wearables.where("gender = #{user_specifications[:gender]} and body_part = #{body_part} and temp_min <= #{weather_data.temperatue} and temp_max >= #{weather_data.temperature}")
  end
end