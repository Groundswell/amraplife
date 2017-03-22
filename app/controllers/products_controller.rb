
class ProductsController < ApplicationController

	before_filter :get_product, only: :show


	def index

		if params[:query].present?
			query = { text: params[:query], published?: true, page: params[:page] }

			@title_mod = "found for \"#{params[:query].truncate(20)}\""

			if params[:category].present? && cat = ProductCategory.friendly.find( params[:category] )
				query[:category_id] = cat.id
				@title_mod = "in #{cat.name}"
			end

			@products = Product.record_search query

		else

			@products = Product.published

			if params[:category].present? && cat = ProductCategory.friendly.find( params[:category] )
				@products = @products.where( category_id: cat.id )
				@title_mod = "in #{cat.name}"
			end

			if params[:tag].present?
				@products = @products.with_any_tags( params[:tag] )
			end

			@products = @products.page( params[:page] )

		end
	end

	def show

		@images = SwellMedia::Asset.where( parent_obj: @product, use: 'gallery' ).active

		set_page_meta( @product.page_meta )
	end

	private

		def get_product
			@product = Product.friendly.find( params[:id] )
		end

end
