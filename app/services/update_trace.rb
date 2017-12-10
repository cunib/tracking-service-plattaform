class UpdateTrace < Base

  def call
    if @delivery_man.errors.empty? && @delivery_man.active_delivery.present?
      delivery_id = @delivery_man.active_delivery.id
      position = Position.create @delivery_man.trace.position.attributes.slice("latitude", "longitude")
      trace = Trace.create(date: DateTime.now, delivery_id: delivery_id, position: position)
      @delivery_man.errors.empty? && trace.errors.empty?
    else
      @delivery_man.errors.empty?
    end
  end
end
