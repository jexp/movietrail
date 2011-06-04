module MovieTrail
  class Event
    @@id = 0
    attr_accessor :type, :key, :data, :places, :times, :id
    def initialize(type, key)
      self.type = type
      self.key = key
      self.data = []
      self.id = @@id
      @@id+=1
    end
    
    def add(type, text)
      data << {type => text}
      analyzer = Analyzer.new(text)
      self.places = (self.places||[]) << analyzer.places
      self.times = (self.times||[]) << analyzer.times
    end

    def to_s 
      "#{key} : #{data.inspect} #{self.places} #{self.times}"
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
              timeline << event unless event.nil?
              event = Event.new(type, text)
            else
              event.add(type,text)
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