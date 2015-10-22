class Wearable < ActiveRecord::Base

  def self.get_appropriate_clothing(user_specifications, weather)
    q = self
      .where("gender = ? or gender = 'U'", user_specifications[:gender])
      .where("min_temp <= ? or min_temp is null", weather.temperature)
      .where("max_temp >= ? or max_temp is null", weather.temperature)
      .where("conditions = ? or conditions is null", weather.condition)
      .pluck(:body_part, :clothing)
    h = Hash.new { |h, k| h[k] = [] }
    q.each { |body_part, clothing| h[body_part] << clothing }
    h
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