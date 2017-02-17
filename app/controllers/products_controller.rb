
class ProductsController < ApplicationController

	before_filter :get_product, only: :show


	def index
		@products = Product.published

		if params[:category].present? && cat = ProductCategory.friendly.find( params[:category] )
			@products = @products.where( category_id: cat.id )
			@title_mod = "in #{cat.name}"
		end
		@products = @products.page( params[:page] )

	end

	def show
		set_page_meta( @product.page_meta )
	end

	private

		def get_product
			@product = Product.friendly.find( params[:id] )
		end

end

