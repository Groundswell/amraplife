
class RecipesController < ApplicationController

	before_action :set_recipe, only: :show


	def index
		@recipes = Recipe.published.order( :title )
		if params[:cat].present?
			@category = RecipeCategory.friendly.find( params[:cat] )
			@recipes = @recipes.where( category_id: @category.id )
		end
		@recipes = @recipes.page( params[:page] )
		set_page_meta( title: 'Recipes )°( AMRAP Life', description: 'Recipes to fuel your AMRAP Life' )
	end

	def show
		@media = @recipe

		@more_recipes = Recipe.published.order('random()').limit( 3 )

		set_page_meta( @recipe.page_meta )
	end


  private
	# Use callbacks to share common setup or constraints between actions.
	def set_recipe
		@recipe = Recipe.published.friendly.find( params[:id] )
	end



end
