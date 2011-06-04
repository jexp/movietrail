require 'rubygems'
require 'uri'
require 'json'
require 'rest-client'
require 'movietrail/domain'
require 'movietrail/events'

module MovieTrail
  class MovieTrail
    attr_accessor :scenes

    def initialize
      @@scenes ||= load
      @@events ||= Events.load
    end

    TIMELINE = JSON.parse(IO.read("trail.json"))

		def timeline
		  @@scenes
		end
		
		def events(id)
       @@events.events(id)
	  end
    def event_count
      @@events.count
    end
		
		def scene(id)
      @@scenes[id]
	  end

    def load
      scene_text = ""
      scenes = []

      File.open("GOLDFINGER.txt", "r") do |infile|
        while (line = infile.gets)
          if line =~ /----(\d+)\./
            if !scene_text.empty?
              scene = Scene.new($1,scene_text)
              puts scene
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
	end
end
