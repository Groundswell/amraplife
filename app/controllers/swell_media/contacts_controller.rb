module SwellMedia
	class ContactsController < ApplicationController
		skip_before_action :verify_authenticity_token, :only => [ :create ]

		def create
			@contact = ContactUs.new( contact_params )

			SwellMedia::Email.create_or_update_by_email( @contact.email, user: current_user )

			if @contact.save

				#SwellMedia::ContactMailer.new_contact( @contact ).deliver if SwellMedia.contact_email_to.present?

				redirect_to thanks_contacts_path

			else
				set_flash 'There was a problem...', :danger, @contact
				redirect_back( fallback_location: root_path )
			end
		end


		def new
			set_page_meta title: 'Contact Us'
			render layout: ( SwellMedia.default_layouts['swell_media/contacts#new'] || SwellMedia.default_layouts['swell_media/contacts'] || 'application' )
		end


		private
			def contact_params
				params.require( :contact_us ).permit( :email, :subject, :message, :optin )
			end

	end
end