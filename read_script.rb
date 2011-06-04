require 'rubygems'
require 'fileutils'
require 'json'

CAST = {
:goldfinger => ["Auric Goldfinger","Auric","Goldfinger"],
:leiter => ["Felix Leiter","Felix", "Leiter"],
:bond => ["James Bond","James","Bond"],
:jill => ["Jill Masterson","Jill"],
:m => ["M"],
:solo => ["Martin Solo","Martin", "Solo"],
:moneypenny => ["Miss Moneypenny","Moneypenny"],
:oddjob => ["Oddjob"],
:pussy => ["Pussy Galore","Pussy", "Galore"],
:q => ["Q"],
:simmons => ["Simmons"],
:tilly => ["Tilly Masterson","Tilly"]}

PLACES = JSON.parse(IO.read("places.json"))
PLACE_NAMES = Hash[JSON.parse(IO.read("places.json")).collect { |name, data| [name, [data['name']]+data['name'].split(/ /) ]}]

class Scene
  attr_accessor :minute, :text, :people, :places

  def scan_text_for(text,what)
    what.collect do |name, tokens | 
      regexp = Regexp.new '\b('+tokens.collect {|t| t.downcase }.join("|")+')\b'
      regexp.match(text).nil? ? nil : name
    end.find_all { |i| !(i.nil?) }.uniq
  end
  
  def initialize(minute, text)
    self.minute = minute
    self.text = text
    lctext = self.text.downcase
    self.people = scan_text_for(lctext, CAST)
    self.places = scan_text_for(lctext, PLACE_NAMES)
  end
  
  def to_s
    "#{minute}: People #{people.join(', ')} Places: #{places.join(', ')}"
  end
end

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
