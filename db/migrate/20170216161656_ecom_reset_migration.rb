class EcomResetMigration < ActiveRecord::Migration
	def change

		# dump legacy in-progress swell_ecom stuff
		# drop_table 	:carts
		# drop_table	:cart_items
		# drop_table 	:coupons 
		# drop_table 	:coupon_redemptions
		# drop_table 	:geo_addresses
		# drop_table 	:geo_countries
		# drop_table 	:geo_states
		# drop_table 	:orders
		# drop_table 	:order_items
		# drop_table 	:plans
		# drop_table 	:products
		# drop_table 	:product_options
		# drop_table 	:shipments
		# drop_table 	:shipment_items
		# drop_table 	:skus
		# drop_table 	:sku_options
		# drop_table 	:subscriptions
		# drop_table 	:tax_rates
		# drop_table 	:transactions


		# temporary product table -- just enough to display products for 
		# shopify buy button integration
		create_table :products do |t|
			t.references 	:category
			t.text 			:shopify_code # maybe product_id, maybe entire html/js snippet
			t.string 		:title
			t.string		:caption
			t.integer 		:seq, default: 1
			t.string 		:slug
			t.string 		:avatar
			t.string 		:brand_model # to store e.g. "Next Level | 3600" for info & to show size charts
			t.integer		:status, 	default: 0
			t.text 			:description
			t.text 			:content
			t.datetime		:publish_at
			t.integer 		:price, default: 0
			t.integer 		:suggested_price, default: 0
			t.integer 		:shipping_price, default: 0
			t.string 		:currency, default: 'USD'
			t.string 		:tags, array: true, default: '{}'
			t.hstore		:properties, default: {}
			t.timestamps
		end
		add_index :products, :tags, using: 'gin'
		add_index :products, :category_id
		add_index :products, :slug, unique: true
		add_index :products, :status
		add_index :products, :seq

		# product_options just hold the different option possibilites
		create_table	:product_options do |t|
			t.references 	:product 
			t.string 		:name, default: :size # the option name: e.g. size, color, style, memory capacity, etc
			t.string 		:values, array: true, default: '{}' # the possible values for the option: e.g. s, m, l, xl
		end
		add_index :product_options, :product_id
		add_index :product_options, :values, using: 'gin'

		# product_variants glom together a collection of options into a single 
		# actual thing that can be shipped or consumed
		# these are the heart of products
		create_table	:product_variants do |t|
			t.references 	:product 
			t.string 		:title
			t.string 		:slug
			t.integer 		:seq, default: 1
			t.string 		:sku
			t.string 		:avatar
			t.integer		:status, 	default: 0
			t.text 			:description
			t.datetime		:publish_at
			t.integer 		:price, default: 0
			t.integer 		:shipping_price, default: 0
			t.integer 		:inventory, default: -1
			t.string 		:tags, array: true, default: '{}'
			t.hstore 		:options, default: {}
			t.hstore		:properties, default: {}
			t.timestamps
		end
		add_index :product_variants, :product_id
		add_index :product_variants, :slug, unique: true
		add_index :product_variants, :seq





		# the combination of options glommed together for a specific variant
		# can probably just stash this in an hstore in variants
		# create_table :product_variant_options do |t|
		# 	t.references 	:product_variant 
		# 	t.references 	:product_option 
		# 	t.string 		:option_value 
		# end
		# add_index :product_variant_options, :product_variant_id
		# add_index :product_variant_options, :product_option_id


	end
end
