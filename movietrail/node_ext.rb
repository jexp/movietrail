require 'rubygems'
require 'neography'

module Neography
  class Node
    class << self
      def create_and_index(data, to_index)
        node = Neography::Node.create(data)
        return node unless to_index
        to_index.each do |index, names|
          names.each do |prop|
            node.neo_server.add_node_to_index(index, prop, data[prop], node.neo_id)
          end
        end
        node
      end

      def obtain(data, to_index)
        if to_index
          res = to_index.collect { |index, props| props.collect { |prop| Node.find(index, prop, data[prop]) } }.flatten().find { |i| i }
          return res if res
        end
        create_and_index(data, to_index)
      end

      def find(index, prop, value)
        res = Neography::Rest.new.get_node_index(index, prop, value)
        return nil unless res
        Neography::Node.load(res.first)
      end
    end
  end
  class Rest
    def get_type(type)
      case type
        when :node, "nodes", :nodes, "nodes"
          "node"
        when :relationship, "relationship", :relationships, "relationships"
          "relationship"
        when :path, "path", :paths, "paths"
          "path"
        when :fullpath, "fullpath", :fullpaths, "fullpaths"
          "fullpath"
        else
          "node"
      end
    end
  end
end