require 'rubygems'
require 'sinatra/base'
require 'uri'
require 'movietrail'

class App < Sinatra::Base
  set :haml, :format => :html5 
  set :app_file, __FILE__
  
  include MovieTrail
  
  before do
    @trail = MovieTrail.new
  end

  NO_PHOTO = "/img/no_photo.png"

  helpers do
      def face(name)
        name = name.downcase
        return  NO_PHOTO unless @cast[name]
        img = @cast[name]['image']
        img ? img : NO_PHOTO
      end
    end

	get '/' do
		@timeline = @trail.timeline
    haml :index
  end

  get '/events' do
    @cast = CAST
    @events = @trail.events(nil)
    haml :events
  end
  
  BASE_URL = "http://movietrail.heroku.com"

  get '/events.rss' do
    content_type 'application/rss+xml'

    @cast = CAST
    @events = @trail.events(nil)
    haml(:rss, :format => :xhtml, :escape_html => true, :layout => false)
  end
  
  get '/events.json' do 
    @trail.events(nil).collect{ |e| {:id => e.id, :type => e.type, :crew => e.crew, :content => e.content, :content_type => e.content_type, :times => e.times, :places => e.places, :people => e.people }}.to_json
  end
  
  get '/timeline' do
    @trail.timeline.collect { |scene| { :time => scene.time, :places => scene.places, :people => scene.people, :times => scene.times }}.to_json
  end

  get '/timeline/:id' do |id|
    scene = @trail.scene(id.to_i)
    { :time => scene.time, :places => scene.places, :text => scene.text, :people => scene.people, :times => scene.times }.to_json
  end
end
