$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
require 'neography'


Bundler.require

Neography::Config.server = ENV['NEO4J_HOST'] || '192.168.2.114'
Neography::Config.port =  (ENV['NEO4J_PORT'] || "7476").to_i
Neography::Config.authentication = 'basic'
Neography::Config.username = ENV['NEO4J_LOGIN']
Neography::Config.password = ENV['NEO4J_PASSWORD']

require 'app'

run App

