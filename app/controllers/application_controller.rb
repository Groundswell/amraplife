class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	helper SwellMedia::Engine.helpers

	before_filter :set_page_meta
	before_filter :allow_iframe_requests
	before_filter :set_cart#, :clear_cart
	
	def allow_iframe_requests
	  response.headers.delete('X-Frame-Options')
	end

	def set_cart
		@cart = SwellEcom::Cart.find_by( id: session[:cart_id] )
	end

	def clear_cart
		session[:cart_count] = 0
	end
end
