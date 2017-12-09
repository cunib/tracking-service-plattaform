class RandomPathStrategy < PathStrategy
 require 'node_with_distances'

 attr_accessor :path, :total_distance, :next_node, :nodes, :distance_hash

 def initialize(source, nodes)
   @nodes = nodes.unshift(source)
   @path = [source]
   @total_distance = 0
   @next_node= source
   @distance_hash = NodeWithDistances.new(@nodes).build_distance_hash
 end

  def build_path
    @path = @nodes
    @path << @nodes.first
    @distance_hash[@next_node].each do |node_to, distance|
      if node_to == @next_node
        @total_distance = @total_distance + distance
      end
    end

    self
  end

  def self.name
    "Armado de recorrido Aleatorio"
  end
end
