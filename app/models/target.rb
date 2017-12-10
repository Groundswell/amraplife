class Target < ActiveRecord::Base

	belongs_to :parent_obj, polymorphic: true
	belongs_to :user

	
end