require 'net/http'

class Autocompleter

  GEOBYTES_URI = "http://gd.geobytes.com/AutoCompleteCity?q="

  def self.complete(q)
    uri = URI(GEOBYTES_URI + q)
    Net::HTTP.get(uri) # => String
  end

end