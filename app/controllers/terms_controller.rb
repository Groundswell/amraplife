class TermsController < ApplicationController

	def index
		@terms = Term.published

		if params[:q].present?
			match = params[:q].downcase.singularize.gsub( /\s+/, '' )
			@terms = @terms.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match )
			@terms = Term.find_by_aliases( match ) if @terms.empty?
		end

		@terms = @terms.sort_by{ |t| t.title.sub(/^the /i, '' ).sub(/^a /i, '' ).downcase }
		@letters = Term.pluck( "left( title, 1 )" ).sort.uniq

		@anchor_idx = 0

		set_page_meta( title: 'Our Ultimate Guide to CrossFit Terms', description: "CrossFit can be intimidating enough as it is, but sometimes the terminology can be overwhelming. Our guide gives you the definitions of over 300 terms." )

	end
	
end