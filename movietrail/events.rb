module MovieTrail
  class Event
    @@id = 0
    # type = actor, movie
    # crew = name , camera, cut, action
    # content
    # content_type
    attr_accessor :type, :crew, :content,:content_type, :places, :times, :id
    def initialize(type, crew)
      self.type = type
      self.crew = crew
      self.id = @@id
      @@id+=1
    end
    
    def add(content, content_type = nil)
      self.content = content
      self.content_type = content_type
      analyzer = Analyzer.new(content)
      self.places =  analyzer.places
      self.times = analyzer.times
      self
    end

    def to_s 
      "#{type} @#{crew} #{content} #{self.places} #{self.times}"
    end
  end

  class Events

    def initialize(events)
      @events = events
      puts events.count
    end

    def self.load
      timeline = []
      event = nil
      File.open("GOLDFINGER2.txt", "r") do |infile|
        while (line = infile.gets)
          if line =~ /^(ACTION|EMOTION|ACTOR|CAMERA|CUT|SPEECH)# (.+)/
            type = $1
            text = $2
            if type =~ /ACTOR/ || type =~ /CAMERA/ || type =~ /CUT/ || type =~ /ACTION/
              if type =~ /ACTOR/ 
                event = Event.new('ACTOR' , text)
              else
                timeline << Event.new('MOVIE' , type).add(text)
              end
            else
              timeline << event.add(text,type)
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