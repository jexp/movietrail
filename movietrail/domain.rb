require 'movietrail/node_ext'

module MovieTrail
  CAST = JSON.parse(IO.read("public/cast.json"))
  PLACES = JSON.parse(IO.read("public/places.json"))
  PLACE_NAMES = Hash[PLACES.collect { |name, data| [name, data['keywords']]}]

  class Scene
    attr_accessor :minute, :text, :people, :places

    def scan_text_for(text,what)
      what.collect do |name, tokens | 
        regexp = Regexp.new '\b('+tokens.collect {|t| t.downcase }.join("|")+')\b'
        regexp.match(text).nil? ? nil : name
      end.find_all { |i| !(i.nil?) }.uniq
    end

    def initialize(minute, text)
      self.minute = minute
      self.text = text
      lctext = self.text.downcase
      self.people = scan_text_for(lctext, CAST)
      self.places = scan_text_for(lctext, PLACE_NAMES)
    end

    def to_s
      "#{minute}: People #{people.join(', ')} Places: #{places}"
    end
  end
end