
class RecipesController < ApplicationController

	before_action :set_recipe, only: :show


	def index
		@recipes = Recipe.published.order( :title )
		@count = @recipes.count
		@recipes = @recipes.page( params[:page] )
		set_page_meta( title: 'Recipes )°( AMRAP Life' )
	end

	def show
	end


  private
	# Use callbacks to share common setup or constraints between actions.
	def set_recipe
		@recipe = Recipe.published.friendly.find( params[:id] )
	end



end