class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	helper SwellMedia::Engine.helpers

	before_filter :force_cloudflare_sll
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

	private
	def force_cloudflare_sll
		puts "X-Forwarded-Proto: '#{request.headers['X-Forwarded-Proto']}'"
		if request.headers['X-Forwarded-Proto'].present? && request.headers['X-Forwarded-Proto'].strip.downcase == 'http'
			puts "redirecting to https"
			# redirect_to request.original_url.gsub('http:', 'https:')
		end

		request.headers.each do |key, value|
			puts "REQUEST.HEADER['#{key}'] = '#{value}'"
		end
	end
end
