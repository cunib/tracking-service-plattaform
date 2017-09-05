class NodeWithDistances
  def initialize(nodes)
    @nodes = nodes
  end

  def build_distance_hash
    distance_hash = {}
    @nodes.each do |first_node|
      distance_hash[first_node] = []
      @nodes.each do |second_node|
        if second_node != first_node
          distance_hash[first_node] <<
            [second_node, nodes_distance(first_node, second_node)]
        end
      end
    end
    distance_hash
  end

  private

  def nodes_distance(origin, target)
    target_lat_lng = [target.latitude, target.longitude]
    origin.distance_from(target_lat_lng)
  end
end
