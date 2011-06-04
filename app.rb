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

		get '/' do
			@timeline = @trail.timeline
    haml :index
  end

  get '/events' do
    @events = @trail.events(nil)
    haml :events
  end
  
  get '/events.json' do 
    @trail.events(nil).collect{ |e| {:id => e.id, :type => e.type, :key => e.key }}.to_json
  end
  
  get '/timeline' do
    @trail.timeline.collect { |scene| { :time => scene.time, :places => scene.places, :people => scene.people, :times => scene.times }}.to_json
  end

  get '/timeline/:id' do |id|
    scene = @trail.scene(id.to_i)
    { :time => scene.time, :places => scene.places, :text => scene.text, :people => scene.people, :times => scene.times }.to_json
  end
end
