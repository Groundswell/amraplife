
class RecipesController < ApplicationController

	before_action :setrecipe, only: :show


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
	def setrecipe
		@recipe = Recipe.friendly.find(params[:id])
	end



end