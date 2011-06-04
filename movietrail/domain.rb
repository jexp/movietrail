require 'movietrail/node_ext'

module MovieTrail

  CAST = JSON.parse(IO.read("public/cast.json"))
  PLACES = JSON.parse(IO.read("public/places.json"))
  PLACE_NAMES = Hash[PLACES.collect { |name, data| [name, data['keywords']]}]
  TIMES = { :day => ["day","daylight"], :morning => ["morning","breakfast","0?[789]:\d\d","sunrise"],
    :night => ["midnight","night","dark","moon","stars"], :evening => ["diner","supper"], 
    :noon => ["lunch","1[12]:\d\d"]}

  class Analyzer
    
    def initialize(text)
      @text = text.downcase
    end
    
    def places
      scan_text_for(@text, PLACE_NAMES)
    end

    def times
      scan_text_for(@text, TIMES)
    end
    
    def people
      scan_text_for(@text, CAST)
    end

    def scan_text_for(text,what)
      what.collect do |name, tokens | 
        regexp = Regexp.new '\b('+tokens.collect {|t| t.downcase }.join("|")+')\b'
        regexp.match(text).nil? ? nil : name
      end.find_all { |i| !(i.nil?) }.uniq
    end
  end

  class Scene
    attr_accessor :minute, :text, :people, :places, :times

    def initialize(minute, text)
      self.minute = minute
      self.text = text
      analyzer = Analyzer.new(text)
      self.people = analyzer.people
      self.places = analyzer.places
      self.times  = analyzer.times
    end

    def to_s
      "#{minute}: People #{people.join(', ')} Places: #{places} Times: #{times}"
    end
  end
end