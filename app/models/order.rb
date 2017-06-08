class Order < ApplicationRecord
  enum status: { created: 0, development: 1, sended: 2, canceled: 3, finalized: 4, suspended: 5 } do
    event :process do
      transition [:created, :suspended] => :development
    end

    event :suspend do
      transition [:created, :development, :sended] => :suspended
    end

    event :cancel do
      transition [:suspended, :development, :sended] => :canceled
    end

    event :dispatch do
      transition [:suspended, :development] => :sended
    end

    event :finalize do
      transition :sended => :finalized
    end
  end

  belongs_to :business
end
