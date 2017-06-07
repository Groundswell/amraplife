class ProductsSeqMigration < ActiveRecord::Migration
	def change
		add_column :products, :seq, :integer, default: 1
	end
end
