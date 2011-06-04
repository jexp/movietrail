require 'json'
CAST = JSON.parse(IO.read("public/cast.json")).collect { |k,v| v }.flatten

nouns = {}
File.open("GOLDFINGER.txt", "r") do |infile|
  while (line = infile.gets)
    line.gsub(/[^\.?! ]\s+([A-Z][a-z]{2,})/) do |w|
      nouns[$1]=(nouns[$1]||0) +1 if w =~ /([A-Z][a-z]{2,})/ && $1.size > 3 && !CAST.include?($1)
    end
  end
end
nouns.keys.each { |k| puts k }