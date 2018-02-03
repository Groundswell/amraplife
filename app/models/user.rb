class User < SwellMedia::User

	devise 		:database_authenticatable, :omniauthable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:facebook], :authentication_keys => [:login]

	before_create 	:set_names
	after_create 	:set_custom_units

	# App declarations
	has_many :metrics
	has_many :observations
	has_many :targets
	has_many :units # custom units entered by the user: e.g. water bottle
	has_many :user_inputs

	has_one :address, class_name: 'SwellEcom::GeoAddress'


	### Class Methods   	--------------------------------------
	# over-riding Deivse method to allow login via name or email
	def self.find_for_database_authentication(warden_conditions)
		conditions = warden_conditions.dup
		if login = conditions.delete(:login)
			where(conditions.to_h).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
		elsif conditions.has_key?(:username) || conditions.has_key?(:email)
			where(conditions.to_h).first
		end
	end

	def self.from_omniauth(auth)

		oauth_credential = SwellMedia::OauthCredential.where( provider: auth.provider, uid: auth.uid ).first_or_initialize

		user = oauth_credential.user

		user ||= where( email: auth.info.email ).first_or_create do |user|

			user.email = auth.info.email
			user.password = Devise.friendly_token[0,20]
			user.full_name = auth.info.name   # assuming the user model has a name
			user.avatar = auth.info.image # assuming the user model has an image

			# If you are using confirmable and the provider(s) you use validate emails,
			# uncomment the line below to skip the confirmation emails.
			# user.skip_confirmation!
		end

		oauth_credential.user = user
		oauth_credential.save

		user
	end

	def self.new_with_session(params, session)
		super.tap do |user|
			if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
				user.email = data["email"] if user.email.blank?
			end
		end
	end



	def to_s( args={} )
		if args[:username]
			str = self.name.try(:strip)
			str = 'Guest' if str.blank?
			return str
		else
			if self.nickname.present?
				str = self.nickname
			elsif self.full_name.present?
				str = self.full_name
			elsif str.blank?
				str = 'Guest'
			end

			return str
		end
	end


	private

		def set_custom_units
			Unit.create( user_id: self.id, name: 'Steps', abbrev: 'step', unit_type: 'length', base_unit_id: Unit.system.find_by_alias( 'meter' ).id, conversion_factor: 0.7112, custom_base_unit_id: Unit.system.find_by_alias( 'inch' ).id, custom_conversion_factor: 28 )
		end

		def set_names
			if self.nickname.blank?
				nick = self.full_name.split( /\s+/ ).first unless self.full_name.blank?
				self.nickname ||= self.email.split( /@/ ).first
			end

			if self.name.blank?
				self.name = self.email.parameterize
			end
		end

end
