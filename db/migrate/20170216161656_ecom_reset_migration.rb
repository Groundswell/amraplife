class EcomResetMigration < ActiveRecord::Migration
	def change

		# dump legacy in-progress swell_ecom stuff
		drop_table 	:carts
		drop_table	:cart_items
		drop_table 	:coupons 
		drop_table 	:coupon_redemptions
		drop_table 	:geo_addresses
		drop_table 	:geo_countries
		drop_table 	:geo_states
		drop_table 	:orders
		drop_table 	:order_items
		drop_table 	:plans
		drop_table 	:products
		drop_table 	:product_options
		drop_table 	:shipments
		drop_table 	:shipment_items
		drop_table 	:skus
		drop_table 	:sku_options
		drop_table 	:subscriptions
		drop_table 	:tax_rates
		drop_table 	:transactions


		# temporary product table -- just enough to display products for 
		# shopify buy button integration
		create_table :products do |t|
			t.references 	:category
			t.text 			:shopify_code # maybe product_id, maybe entire html/js snippet
			t.string 		:title
			t.string		:caption
			t.string 		:slug
			t.string 		:avatar
			t.integer		:status, 	default: 0
			t.text 			:description
			t.text 			:content
			t.datetime		:publish_at
			t.integer 		:price, default: 0
			t.integer 		:suggested_price, default: 0
			t.string 		:currency, default: 'USD'
			t.string 		:tags, array: true, default: '{}'
			t.hstore		:properties, default: {}
			t.timestamps
		end
		add_index :products, :tags, using: 'gin'
		add_index :products, :category_id
		add_index :products, :slug, unique: true
		add_index :products, :status

	end
end
