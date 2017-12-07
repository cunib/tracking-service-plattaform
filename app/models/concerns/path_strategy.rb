class PathStrategy
  STRATEGY_TYPES = %w(DijkstraPathStrategy RandomPathStrategy)

  def self.strategy_types
    STRATEGY_TYPES
  end

  def build_path
    raise NotImplementedError, 'Refer to subclass'
  end
end
