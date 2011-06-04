require 'rubygems'
require 'uri'
require 'json'
require 'rest-client'
require 'movietrail/domain'

module MovieTrail
  class MovieTrail
    attr_accessor :timeline

    def initialize
      self.timeline = load
    end

    TIMELINE = JSON.parse(IO.read("trail.json"))
		def timeline
			TIMELINE
		end

    def load
      scene_text = ""
      timeline = []

      File.open("GOLDFINGER.txt", "r") do |infile|
        while (line = infile.gets)
          if line =~ /----(\d+)\./
            if !scene_text.empty?
              scene = Scene.new($1,scene_text)
              puts scene
              timeline << scene
            end
            scene_text = ""
          else
            scene_text += line
          end
        end
      end
      timeline
    end
	end
end
