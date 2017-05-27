class RecipeCategoryMigration < ActiveRecord::Migration
	def change
		add_column :recipes, :category_id, :integer
		add_index :recipes, :category_id

		add_column :products, :notes, :text
	end
end
