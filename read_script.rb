require 'fileutils'

cast = {
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

places = {}

timeline = []
class Scene
  attr_accessor :minute, :text, :people, :location
  def initialize(_minute, _text)
    minute = _minute
    text = _text
    people = cast.collect do |name, tokens | 
      regexp = "("+tokens.collect {|t| t.downcase }.join("|")+")"
      _text.downcase =~ regexp ? name : nil
    end.find_all { |i| !i.nil? }
  end
  def to_s
    "#{minute}: #{people}"
  end
end

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
