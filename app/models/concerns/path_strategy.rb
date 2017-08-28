class PathStrategy < OpenStruct
  STRATEGY_TYPES = %w(ShortestPathStrategy)

  def self.strategy_types
    STRATEGY_TYPES
  end

  def build_path
    raise NotImplementedError, 'Refer to subclass'
  end
end
