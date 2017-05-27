
class RecipeAdminController < SwellMedia::AdminController
	before_action :set_recipe, only: [:show, :edit, :preview, :update, :destroy]

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

	def preview
		@media = @recipe
		set_page_meta( @recipe.page_meta )
		render "recipes/show", layout: 'application'
	end

	def update

		@recipe.attributes = recipe_params
		
		if params[:recipe][:category_name].present?
			@recipe.category_id = RecipeCategory.where( name: params[:recipe][:category_name] ).first_or_create( status: 'active' ).id
		end
		
		if @recipe.save
			set_flash 'Recipe Updated'
			redirect_to edit_recipe_admin_path( id: @recipe.id )
		else
			set_flash 'Recipe could not be Updated', :error, @recipe
			render :edit
		end

	end


	private
		def recipe_params
			params.require( :recipe ).permit( :title, :description, :avatar, :content, :status, :prep_time, :cook_time, :serves, :tags_csv, :category_id ) 	
		end

		def set_recipe
			@recipe = Recipe.friendly.find( params[:id] )
		end
end
