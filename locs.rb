require 'rubygems'
require 'json'
require 'geonames'

places = ["Miami Beach",
"Capungo",
"London",
"British Isles",
"United States",
"Washington",
"Westminster",
"Europe",
"England",
"Fort Knox",
"Kentucky",
"Zurich",
"Amsterdam",
"Caracas",
"Hong Kong",
"Pakistan",
"Kent",
"Lake",
"Salzkammergut",
"Essen",
"Geneva",
"Newfoundland",
"Baltimore",
"Sydney",
"Switzerland",
"Chicago",
"Mexico",
"Bahamas",
"Cuba",
"Cape Kennedy",
"White House"]

output = places.collect do |name|
  postal_code_sc = Geonames::PostalCodeSearchCriteria.new
  postal_code_sc.place_name = name
  postal_codes = Geonames::WebService.postal_code_search postal_code_sc
  if postal_codes && !postal_codes.empty? 
    place = postal_codes[0]
    [ name.gsub(/ /,'_').downcase, 
      {
        :keywords => [name],
        :name => name,
        :longitude => place.longitude,
        :latitude => place.latitude
       }]
  else 
    nil
  end
end

output = Hash[output]
puts output

File.open("places2.json", 'w') {|f| f.write(output.to_json) }

