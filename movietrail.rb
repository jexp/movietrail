require 'rubygems'
require 'uri'
require 'json'
require 'rest-client'
require 'movietrail/domain'
require 'movietrail/events'

module MovieTrail
  class MovieTrail
    @@movies = {}
    MOVIE_FILES = { "1" => "GOLDFINGER", "2" => "forrest_gump"}
    def initialize
    end

    def movie(id)
      raise "Unknown Movie #{id}" unless MOVIE_FILES[id]
      unless @@movies[id]
        @@movies[id]=Movie.load(id,MOVIE_FILES[id])
      end
      @@movies[id]
    end
    
		def timeline(movie_id)
		  movie(movie_id).timeline
		end
		
		def events(movie_id,id)
		   movie(movie_id).events(id)
	  end
    def event_count
      movie(movie_id).event_count
    end
		
		def scene(movie_id, id)
      movie(movie_id).scene(id)
	  end
	end
end
