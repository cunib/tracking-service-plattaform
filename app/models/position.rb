class Position < ApplicationRecord
 #reverse_geocoded_by :latitude, :longitude do |obj,results|
 #  if geo = results.first
 #    obj.order.address = geo
 #  end
 #end
 # after_validation :reverse_geocode  # auto-fetch address

end
