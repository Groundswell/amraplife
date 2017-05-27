class RecipeCategoryMigration < ActiveRecord::Migration
	def change
		add_column :recipes, :category_id, :integer
		add_index :recipes, :category_id

		add_column :recipes, :tags, :string, array: true, default: []
		add_index :recipes, :tags, using: :gin

		add_column :products, :notes, :text
	end
end
