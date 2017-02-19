
class ProductOption < ActiveRecord::Base
	
	enum status: { 'draft' => 0, 'active' => 1, 'archive' => 2, 'trash' => 3 }

	include SwellMedia::Concerns::AvatarAsset

	belongs_to :product 

	acts_as_taggable_array_on :values


	def self.published
		where.not( id: nil )
	end




	def values_csv
		self.values.join(',')
	end

	def values_csv=(values_csv)
		self.values = values_csv.split(/,\s*/)
	end

end