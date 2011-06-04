require 'rubygems'
require 'sinatra/base'
require 'uri'
require 'movietrailer'

class App < Sinatra::Base
  set :haml, :format => :html5 
  set :app_file, __FILE__

  include MovieTrailer

  before do
    @trailer = MovieTrailer.new
  end

  get '/' do
    @timeline = @trailer.timeline
    haml :index
  end
end
