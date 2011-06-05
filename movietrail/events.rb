module MovieTrail
  class Event
    @@id = 0
    # type = actor, movie
    # crew = name , camera, cut, action
    # content
    # content_type
    attr_accessor :type, :crew, :content,:content_type, :id, :env
    def initialize(type, crew)
      self.type = type
      self.crew = crew.split(' ').collect { |w| w.capitalize }.join(" ")
      self.id = @@id
      @@id+=1
    end
    
    def add(content, content_type = nil)
      self.content = content
      self.content_type = content_type
      self
    end

    def is_actor?
      type == "ACTOR"
    end
    
    def times
      self.env.time
    end
    def places
      self.env.place
    end
    def people
      self.env.people
    end
    
    def to_s 
      "#{type} @#{crew} #{content} #{self.places} #{self.times}"
    end
  end
  
  class Environment
    attr_accessor :people, :time, :place
    def initialize(place=nil, time=nil, people=[])
      self.people = people
      self.place = place
      self.time = time
    end
    
    def enrich(event)
      update(event.content)
      add(event.crew) if event.is_actor?
      event.env = current
      event
    end
  
    def add(person)
      person = person.downcase
      self.people << person unless self.people.include? person
    end
    
    def update(text)
      analyzer = Analyzer.new(text)
      place = analyzer.places.first 
      unless place.nil? || place == self.place
        self.place = place
        self.people = []
      end
      unless analyzer.people.nil?
        analyzer.people.each { |p| add(p) } 
      end
      time = analyzer.times.first
      self.time = time unless time.nil? || time == self.time
    end
    
    def current
      Environment.new(self.place,self.time,self.people.dup)
    end
  end

  class Events

    def initialize(events)
      @events = events
      puts events.count
    end

    def self.load
      timeline = []
      env = Environment.new
      event = nil
      File.open("GOLDFINGER2.txt", "r") do |infile|
        while (line = infile.gets)
          if line =~ /^(ACTION|EMOTION|ACTOR|CAMERA|CUT|SPEECH)# (.+)/
            type = $1
            text = $2
            event = Event.new('ACTOR' , text) if type =~ /ACTOR/
            timeline << env.enrich(Event.new('MOVIE' , type).add(text)) if type =~ /CAMERA/ || type =~ /CUT/ || type =~ /ACTION/
            if type =~ /SPEECH/ || type =~ /EMOTION/
              timeline << env.enrich(event.add(text,type))
              event = Event.new(event.type,event.crew)
            end
          end
        end
      end
      Events.new(timeline)
    end

    def events(id = nil)
      return @events if id.nil?
      return @events[id.to_i] unless id.include?("-")
      idx = id.split(/-/).collect{ |i| i.to_i }
      @events[idx[0]..idx[1]]
    end
    def count
      @events.size
    end
  end
end