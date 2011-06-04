require 'rubygems'
require 'sinatra/base'
require 'uri'
require 'movietrail'

class App < Sinatra::Base
  set :haml, :format => :html5 
  set :app_file, __FILE__
  
  include MovieTrail
  
  before do
    @trail ||= MovieTrail.new
  end

  get '/' do
    @timeline = @trail.timeline
    haml :index
  end
  
  get '/timeline' do
    @trail.timeline.to_json
  end
end
