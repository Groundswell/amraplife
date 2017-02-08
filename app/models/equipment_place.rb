
class EquipmentPlace < ActiveRecord::Base

	belongs_to :equipment 
	belongs_to :place 
	
end