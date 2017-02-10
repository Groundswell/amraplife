
class RecipeAdminController < SwellMedia::AdminController
	before_action :set_recipe, only: [:show, :edit, :update, :destroy]

	def create
		@recipe = Recipe.new( recipe_params )
		@recipe.save 
		redirect_to edit_recipe_admin_path( @recipe )
	end

	def destroy
		@recipe.destroy
		redirect_to recipes_url
	end

	def index
		by = params[:by] || 'title'
		dir = params[:dir] || 'asc'
		@recipes = Recipe.order( "#{by} #{dir}" )
		if params[:q]
			match = params[:q].downcase.singularize.gsub( /\s+/, '' )
			@recipes = @recipes.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match )
			@recipes << Recipe.find_by_alias( match )
		end
		@recipe_count = @recipes.count
		@recipes = @recipes.page( params[:page] )
		
	end

	def update
		@recipe.update( recipe_params )
		redirect_to :back
	end


	private
		def recipe_params
			params.require( :recipe ).permit( :title, :description, :content, :status, :lat, :long, :address1, :address2, :city, :state, :zip, :phone, :hours, :cost ) 	
		end

		def set_recipe
			@recipe = Recipe.friendly.find( params[:id] )
		end
end