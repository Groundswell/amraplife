
Rails.application.routes.draw do

	# resources :cards do
	# 	get :success, on: :member
	# end

	resources :lifemeter, only: :index do
		get :settings, on: :collection
		put :update_settings, on: :collection
		get :dash, on: :collection
		get :help, on: :collection
		get :log, on: :collection
	end

	scope 'lifemeter' do
		resources :journal_entries
		resources :metrics
		resources :observations
		resources :stats
		resources :targets
		resources :custom_units
	end

	resources :equipment
	resources :equipment_admin

	resources :feed, only: :index

	resources :inspiration_admin do
		get :preview, on: :member
	end

	# resources :metrics
	resources :metric_admin

	resources :movements
	resources :movement_admin


	resources :observation_admin


	get '/lifemeter/slack/:team_id/:user/:token' => 'observation_slack_bots#login', as: 'login_observation_slack_bots'
	get '/lifemeter/facebook/:user/:token' => 'observation_facebook_bots#login', as: 'login_observation_facebook_bots'
	resources :observation_alexa_skills, only: :create do
		get :login, on: :collection
		get :login_success, on: :collection
	end
	resources :observation_google_actions, only: :create do
		get :login, on: :collection
		get :login_success, on: :collection
	end
	resources :observation_facebook_bots, only: :create do
		get :create, on: :collection
		get :login_success, on: :collection
	end
	resources :observation_slack_bots, only: :create do
		get :install_callback, on: :collection
		get :login_success, on: :collection
	end

	# resources :observations do
	# 	put :stop, on: :member
	# end

	resources :places
	resources :place_admin

	resources :recipes
	resources :recipe_admin do
		get :preview, on: :member
	end

	# resources :stats

	resources :terms, only: :index, path: 'crossfit-terms'
	resources :term_admin do
		delete :empty_trash, on: :collection
	end

	resources :unit_admin
	resources :user_input_admin

	resources :user_inputs, only: :create

	resources :workouts
	resources :workout_admin

	resources :workout_results

	resources :workout_movements
	resources :workout_segments

	get '/about' => 'swell_media/static#about', as: 'about'

	get '/faq' => 'swell_media/static#faq', as: 'faq'

	get '/inspirations' => 'swell_media/static#inspirations', as: 'inspirations'
	get '/deleteGAPPSnotBefore20170225utc.html' => 'swell_media/static#goog_verify'

	devise_scope :user do
		get '/forgot' => 'sessions#forgot', as: 'forgot'
		get '/login' => 'sessions#new', as: 'login'
		get '/logout' => 'sessions#destroy', as: 'logout'
		get '/register' => 'registrations#new', as: 'register'
	end
	devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => 'registrations', :sessions => 'sessions' }

	mount SwellEcom::Engine, :at => '/'

	mount SwellMedia::Engine, :at => '/'

end
