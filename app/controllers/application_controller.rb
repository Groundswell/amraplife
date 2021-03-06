class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	helper SwellMedia::Engine.helpers

	before_filter :set_page_meta
	before_filter :allow_iframe_requests
	before_filter :set_cart#, :clear_cart

	around_action :set_timezone, if: :current_user

	def allow_iframe_requests
	  response.headers.delete('X-Frame-Options')
	end

	def set_cart
		@cart = SwellEcom::Cart.find_by( id: session[:cart_id] )
	end

	def clear_cart
		session[:cart_count] = 0
	end


	def after_sign_in_path_for(resource)
		if ( oauth_uri = session.delete(:oauth_uri) ).present?
			return oauth_uri
		elsif resource.admin?
			return '/admin'
		else
			return '/lifemeter'
		end
	end


	private
		def set_timezone( &block )
			Time.use_zone( current_user.timezone, &block )
			
		end

end
