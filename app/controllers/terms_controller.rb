class TermsController < ApplicationController

	def index
		@terms = Term.published
		@terms = @terms.sort_by{ |t| t.title.sub(/^the /i, '' ).sub(/^a /i, '' ).downcase }
		@letters = Term.pluck( "left( title, 1 )" ).sort.uniq
		#@letters = ('a'..'z').to_a
		@anchor_idx = 0
		# if params[:q].present?
		# 	match = params[:q].downcase.singularize.gsub( /\s+/, '' )
		# 	@terms = @terms.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match )
		# 	@terms << Movement.find_by_alias( match )
		# end

	end
	
end