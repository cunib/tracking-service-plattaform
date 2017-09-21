class UpdateTrace < Base

  def call
    if @delivery_man.errors.empty? && @delivery_man.active_delivery.present?
      delivery_id = @delivery_man.active_delivery.id
      trace = Trace.create(@delivery_man.trace.attributes.slice("date", "position_id").merge(delivery_id: delivery_id))
      @delivery_man.errors.empty? && trace.errors.empty?
    else
      @delivery_man.errors.empty?
    end
  end
end
