require 'movietrail/node_ext'

module MovieTrail

  CAST = JSON.parse(IO.read("public/cast.json"))
  CAST_NAMES = Hash[CAST.collect { |name, data| [name, data['keywords']]}]
  
  PLACES = JSON.parse(IO.read("public/places.json"))
  PLACE_NAMES = Hash[PLACES.collect { |name, data| [name, data['keywords']]}]
  TIMES = { :day => ["day","daylight","morning","breakfast",'0?[7-9]:\d\d','1[0-2]:\d\d',"sunrise","lunch","afternoon"],
    :night => ["midnight","night","dark","moon","stars","diner","supper","sunset"]}

  class Movie
    attr_accessor :title, :id, :scenes, :all_events
    
    def timeline
		  self.scenes
		end
		
		def events(id=nil)
       self.all_events.events(id)
	  end

    def event_count
      self.all_events.count
    end
		
		def scene(id)
      self.scenes[id]
	  end
	  
	  def self.load_scenes(name)
      scene_text = ""
      scenes = []

      File.open("#{name}.scenes", "r") do |infile|
        while (line = infile.gets)
          if line =~ /----(\d+)\./
            if !scene_text.empty?
              scene = Scene.new($1,scene_text)
              scenes << scene
            end
            scene_text = ""
          else
            scene_text += line
          end
        end
      end
      scenes
    end
    
	  def self.load(id, name)
      movie = Movie.new
      movie.id = id
      movie.title = name
      movie.scenes = Movie.load_scenes(name)
      movie.all_events = Events.load(name)
      movie
    end
  end
  
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
      scan_text_for(@text, CAST_NAMES)
    end

    def scan_text_for(text,what)
      what.collect do |name, tokens | 
        regexp = Regexp.new '\b('+tokens.collect {|t| t.downcase }.join("|")+')\b'
        regexp.match(text).nil? ? nil : name
      end.find_all { |i| !(i.nil?) }.uniq
    end
  end

  class Scene
    attr_accessor :time, :text, :people, :places, :times

    def initialize(time, text)
      self.time = time
      self.text = text
      analyzer = Analyzer.new(text)
      self.people = analyzer.people
      self.places = analyzer.places
      self.times  = analyzer.times
    end

    def to_s
      "#{time}: People #{people.join(', ')} Places: #{places} Times: #{times}"
    end
  end
end
