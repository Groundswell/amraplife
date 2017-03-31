class PlacesModel < ActiveRecord::Migration
	def change
		add_column	:places, :title_image, :text
	end
end
