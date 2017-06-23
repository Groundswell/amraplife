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


	def after_sign_in_path_for(resource)

		if session[:dest].present? &&
				not( session[:dest].match( /^\/users/ ) ) &&
				not( session[:dest].match( /^\/login/ ) ) &&
				not( session[:dest].match( /^\/logout/ ) ) &&
				not( session[:dest].match( /^\/register/ ) ) &&
				not( session[:dest].match( /^\/oauth_email_collector/ ) )

			path = session[:dest]
			path = path + (path.include?('?') ? '&' : '?') + "oauth_sign_in=1" unless path.include?('oauth_sign_in=1')
		else
			path = '/'
		end

		path
	end

end
