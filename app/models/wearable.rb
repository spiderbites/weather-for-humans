class Wearable < ActiveRecord::Base
  def self.get_body_parts
    Wearable.distinct.select(:body_part).map(&:body_part)
  end

  def self.get_appropriate_clothing(body_part, user_specifications, weather)
     result = Wearable.where("(gender = '#{user_specifications[:gender]}' or gender = 'U') and body_part = '#{body_part}' and min_temp <= #{weather.temperature} and max_temp >= #{weather.temperature}")
     result.map { |wearable| wearable.clothing }
  end

  def self.need_extras(body_part, condition)
    result = Wearable.where("body_part ='#{body_part}' and conditions = #{condition}")
    result.map { |wearable| wearable.clothing }
  end

  # given a list of lists of clothing, removing all items in list i+1 that appeared in list i
  def self.prune(clothing_hashes)
    ret = []
    all_values = []
    clothing_hashes.each do |h|
      new_h = prune_helper(all_values, h)
      ret << new_h
      all_values += new_h.values
    end
    ret
  end

  private
    # return a version of list2 with all items that appear in list1 removed
    def self.prune_helper(values_to_remove, h)
      h.select { |k,v| !values_to_remove.include?(v) } 
    end

end



{"body-layer-4"=>["light-jacket"], "legs"=>["pants"], "feet"=>["shoes"]}
{"body-layer-4"=>["light-jacket"], "legs"=>["pants"], "feet"=>["shoes"], "overhead"=>["umbrella"]}