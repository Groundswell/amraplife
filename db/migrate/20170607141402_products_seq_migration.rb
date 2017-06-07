class ProductsSeqMigration < ActiveRecord::Migration
	def change
		unless column_exists? :products, :seq
			add_column :products, :seq, :integer, default: 1
		end
	end
end
