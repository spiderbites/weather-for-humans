class Wearable < ActiveRecord::Base
  def self.get_body_parts
    Wearable.distinct.select(:body_part).map(&:body_part)
  end

  def self.get_appropriate_clothing(body_part, user_specifications, weather)
     result = Wearable.where("(gender = '#{user_specifications[:gender]}' or gender = 'U') and body_part = '#{body_part}' and min_temp <= #{weather.temperature} and max_temp >= #{weather.temperature}")
     result.map { |wearable| wearable.clothing }
  end

  def self.need_extras(body_part, weather)
    result = Wearable.where("body_part ='#{body_part}' and conditions = #{weather.condition} and (min_temp <= #{weather.temperature} or min_temp = null) and (max_temp >= #{weather.temperature} or max_temp = null)")
    result.map { |wearable| wearable.clothing }
  end

end