
class JournalEntriesController < ApplicationController
	before_filter :authenticate_user!
	before_filter :get_entry, except: [ :create, :index ]

	layout 'lifemeter'

	def create
		
	end

	def destroy
	
	end

	def index
		@entries = current_user.observations.journal_entry.order( created_at: :desc )
	end

	def update
		
	end


	private
		def get_entry
			
		end

		def target_params

		end

end