class Wearables < ActiveRecord::Base
  def self.get_body_parts
    Wearables.distinct.select(:body_part).map(&:body_part)
  end

end