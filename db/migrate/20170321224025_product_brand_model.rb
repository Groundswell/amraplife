class ProductBrandModel < ActiveRecord::Migration
	def change
		add_column	:products, :brand, :string
		add_column	:products, :model, :string
		add_column	:products, :size_info, :string
	end
end
