class Base
  attr_reader :delivery_man

  def self.call(*args)
    new(*args).call
  end

  def initialize(params)
    @delivery_man = DeliveryMan.find(params.delete :delivery_man_id)
    @delivery_man.trace.update_position params[:latitude], params[:longitude]
  end

  private

  def load_errors(errors)
    if errors.messages.any?
      @delivery_man.errors = errors.full_messages
    end
  end

  def serialize_attributes(delivery_man)
    delivery_man.serializable_hash
  end
end
