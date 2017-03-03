
class RecipesController < ApplicationController

	before_action :set_recipe, only: :show


	def index
		@recipes = Recipe.published.order( :title )
		@count = @recipes.count
		@recipes = @recipes.page( params[:page] )
		set_page_meta( title: 'Recipes )°( AMRAP Life', description: 'Recipes to fuel your AMRAP Life' )
	end

	def show
		@media = @recipe

		set_page_meta( @recipe.page_meta )
	end


  private
	# Use callbacks to share common setup or constraints between actions.
	def set_recipe
		@recipe = Recipe.published.friendly.find( params[:id] )
	end



end
