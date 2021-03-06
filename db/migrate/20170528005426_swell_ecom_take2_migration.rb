class SwellEcomTake2Migration < ActiveRecord::Migration
	def change


		reversible do |dir|
			dir.up do
				change_column :products, :size_info, :text
			end
			dir.down do
				change_column :products, :size_info, :string
			end
		end

		# remove cruft from the launch
		drop_table :cards
		drop_table :card_designs


		# swell_media adds ability to semi-obsure optin-lookup
		# so can more easily msg opt-in thx e.g. with giveaway downloads, etc
		add_column :contacts, :code, :string
		add_index :contacts, :code, unique: true

		add_column :products, :collection_id, :integer
		add_column :products, :shipping_price, :integer, default: 0 unless column_exists?( :products, :shipping_price )
		add_column :products, :tax_code, :string, default: '00000'

		# drop_table :product_options
		# drop_table :product_variants

		create_table :carts do |t|
			t.references	:user
			t.integer		:status, default: 1
			t.integer		:subtotal, default: 0
			t.integer 		:estimated_tax, default: 0
			t.integer 		:estimated_shipping, default: 0
			t.integer 		:estimated_total, default: 0
			t.string		:ip
			t.hstore		:properties, 	default: {}
			t.timestamps
		end
		add_index :carts, :user_id

		create_table :cart_items do |t|
			t.references 	:cart
			t.references 	:item, polymorphic: true
			t.integer 		:quantity, default: 1
			t.integer 		:price, default: 0
			t.integer 		:subtotal, default: 0
			t.hstore		:properties, 	default: {}
			t.timestamps
		end
		add_index :cart_items, :cart_id
		add_index :cart_items, [ :item_id, :item_type ]

		create_table :geo_addresses do |t|
			t.references	:user
			t.references	:geo_state
			t.references	:geo_country
			t.integer 		:status
			t.string		:address_type
			t.string		:title
			t.string		:first_name
			t.string		:last_name
			t.string		:street
			t.string		:street2
			t.string		:city
			t.string		:state
			t.string		:zip
			t.string		:phone
			t.boolean		:preferred, :default => false
			t.timestamps
		end
		add_index :geo_addresses, :user_id
		add_index :geo_addresses, [ :geo_country_id, :geo_state_id ]

		create_table :geo_countries do |t|
			t.string   :name
			t.string   :abbrev
			t.timestamps
		end

		create_table :geo_states do |t|
			t.references	:geo_country
			t.string		:name
			t.string		:abbrev
			t.string		:country
			t.timestamps
		end
		add_index :geo_states, :geo_country_id

		create_table :orders do |t|
			t.references 	:user
			t.references 	:billing_address
			t.references 	:shipping_address
			t.string 		:code
			t.string 		:email
			t.integer 		:status, default: 0
			t.integer 		:subtotal, default: 0
			t.integer 		:tax, default: 0
			t.integer 		:shipping, default: 0
			t.integer 		:total, defualt: 0
			t.string 		:currency, default: 'USD'
			t.text 			:customer_notes
			t.text 			:support_notes
			t.datetime 		:fulfilled_at
			t.hstore		:properties, 	default: {}
			t.timestamps
		end
		add_index 	:orders, [ :user_id, :billing_address_id, :shipping_address_id ], name: 'user_id_addr_indx'
		add_index 	:orders, [ :email, :billing_address_id, :shipping_address_id ], name: 'email_addr_indx'
		add_index 	:orders, [ :email, :status ]
		add_index 	:orders, :code, unique: true

		create_table :order_items do |t|
			t.references 	:order
			t.references 	:item, polymorphic: true
			t.string 		:title
			t.integer 		:quantity, default: 1
			t.integer 		:price, default: 0
			t.integer 		:subtotal, default: 0
			t.string		:tax_code, default: nil
			t.integer		:order_item_type, default: 1
			t.hstore		:properties, 	default: {}
			t.timestamps
		end
		add_index :order_items, [ :item_id, :item_type, :order_id ]
		add_index :order_items, [ :order_item_type, :order_id ]

		create_table :product_variants do |t|
			t.references 	:product
			t.string 		:title
			t.string 		:slug
			t.string 		:avatar
			t.string 		:option_name, default: :size
			t.string 		:option_value
			t.text 			:description
			t.integer 		:status, default: 1
			t.integer 		:seq, default: 1
			t.integer 		:price, default: 0
			t.integer 		:shipping_price, default: 0
			t.integer 		:inventory, default: -1
			t.hstore 		:properties, default: {}
			t.datetime 		:publish_at
			t.timestamps
		end
		add_index :product_variants, :product_id
		add_index :product_variants, :seq
		add_index :product_variants, :slug, unique: true
		add_index :product_variants, [ :option_name, :option_value ]

		create_table :transactions do |t|
			t.references	:parent_obj, polymorphic: true  # order, refund, etc.
			t.integer		:transaction_type, default: 1 # payment, refund, chargeback
			t.string 		:provider
			t.string 		:reference_code
			t.integer 		:amount, default: 0
			t.string 		:currency, default: 'USD'
			t.integer 		:status, default: 1
			t.hstore 		:properties, default: {}
			t.timestamps
		end
		add_index :transactions, [ :parent_obj_id, :parent_obj_type ]
		add_index :transactions, :reference_code

	end
end
