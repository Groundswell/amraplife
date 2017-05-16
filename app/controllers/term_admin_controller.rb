
class TermAdminController < SwellMedia::AdminController 
	before_action :set_term, only: [:show, :edit, :update, :destroy]

	def create
		@term = Term.new( term_params )
		@term.save 
		redirect_to edit_term_admin_path( @term )
	end

	def destroy
		@term.destroy
		redirect_to term_admin_index_path
	end

	def index
		by = params[:by] || 'title'
		dir = params[:dir] || 'asc'
		@terms = Term.order( "#{by} #{dir}" )
		if params[:q]
			match = params[:q].downcase.singularize.gsub( /\s+/, '' )
			@terms = @terms.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match )
			@terms << Term.find_by_alias( match )
		end

		@terms = @terms.page( params[:page] )
		
	end

	def update
		@term.update( term_params )
		redirect_to :back
	end


	private
		def term_params
			params.require( :term ).permit( :title, :aliases_csv, :content, :status ) 	
		end

		def set_term
			@term = Term.friendly.find( params[:id] )
		end
end