Rails.application.routes.draw do

	resources :cards do
		get :success, on: :member
	end

	resources :dash, only: :index

	resources :equipment
	resources :equipment_admin

	resources :feed, only: :index

	resources :inspiration_admin do
		get :preview, on: :member
	end

	resources :movements
	resources :movement_admin

	resources :observations

	resources :places
	resources :place_admin

	resources :products, path: :store

	resources :product_admin do
		get :preview, on: :member
		delete :empty_trash, on: :collection
	end

	resources :recipes
	resources :recipe_admin do
		get :preview, on: :member
	end

	resources :terms, only: :index, path: 'terms'
	resources :term_admin do
		delete :empty_trash, on: :collection
	end

	resources :workouts
	resources :workout_admin

	resources :workout_results

	resources :workout_movements
	resources :workout_segments

	get '/about' => 'swell_media/static#about', as: 'about'
	get '/crossfit-terms' => 'swell_media/static#crossfit_terms'
	get '/faq' => 'swell_media/static#faq', as: 'faq'
	get '/inspirations' => 'swell_media/static#inspirations', as: 'inspirations'
	get '/deleteGAPPSnotBefore20170225utc.html' => 'swell_media/static#goog_verify'

	devise_scope :user do
		get '/login' => 'sessions#new', as: 'login'
		get '/logout' => 'sessions#destroy', as: 'logout'
		get '/register' => 'registrations#new', as: 'register'
	end
	devise_for :users, :controllers => { :omniauth_callbacks => 'oauth', :registrations => 'registrations', :sessions => 'sessions' }

	#mount SwellEcom::Engine, :at => '/'

	mount SwellMedia::Engine, :at => '/'

end
