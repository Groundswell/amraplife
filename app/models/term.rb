class Term < ActiveRecord::Base
	enum status: { 'draft' => 0, 'active' => 1, 'archive' => 2, 'trash' => 3 }

	validates		:title, presence: true, unless: :allow_blank_title?

	include SwellMedia::Concerns::AvatarAsset
	#include SwellMedia::Concerns::ExpiresCache

	validate :unique_aliases

	attr_accessor	:slug_pref
	
	include FriendlyId
	friendly_id :title, use: [ :slugged, :history ]


	def self.find_by_alias( q )
		where( ":q = ANY( aliases )", q: q ).first
	end

	def self.find_by_aliases( q )
		where( ":q = ANY( aliases )", q: q )
	end

	def self.published( args = {} )
		where( "char_length(content) > 0" ).active
	end

	



	def aliases_csv
		self.aliases.join( ', ' )	
	end

	def aliases_csv=( aliases_csv )
		self.aliases = aliases_csv.split( /,\s*/ )
	end

	def published?
		self.active? && self.content.present?
	end

	def sanitized_content
		ActionView::Base.full_sanitizer.sanitize( self.content )
	end

	def to_s
		self.title
	end



	private

		def allow_blank_title?
			self.slug_pref.present?
		end

		def unique_aliases
			existing_aliases = Term.where.not( id: self.id ).pluck( :aliases ).flatten
			self.aliases = self.aliases.uniq - existing_aliases
		end
	
end