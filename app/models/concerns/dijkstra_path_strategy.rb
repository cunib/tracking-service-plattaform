class DijkstraPathStrategy < PathStrategy
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
      next_posible_node = @next_node
    while @path.size < @nodes.size
      min_distance = 999999
      @distance_hash[next_node].each do |node_to, distance|
        unless @path.include?(node_to)
          if distance < min_distance
            min_distance = distance
            next_posible_node = node_to
          end
        end
      end
      unless @path.include?(next_posible_node)
        @next_node = next_posible_node
        @total_distance = @total_distance + min_distance
        @path << @next_node
      end
    end

    @path << @nodes.first
    @distance_hash[@next_node].each do |node_to, distance|
      if node_to == @next_node
        @total_distance = @total_distance + distance
      end
    end

    self
  end

  def self.name
    "Armado de recorrido más corto"
  end
end
