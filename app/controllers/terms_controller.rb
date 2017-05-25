class TermsController < ApplicationController

	def index
		@terms = Term.published.order( title: :asc )
		
		# if params[:q].present?
		# 	match = params[:q].downcase.singularize.gsub( /\s+/, '' )
		# 	@terms = @terms.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match )
		# 	@terms << Movement.find_by_alias( match )
		# end

	end
	
end