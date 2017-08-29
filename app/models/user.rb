class User < SwellMedia::User

	devise 		:database_authenticatable, :omniauthable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:facebook], :authentication_keys => [:login]

	after_create :set_name

	# App declarations
	has_many :metrics
	has_many :observations
	has_many :user_inputs


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
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			user.email = auth.info.email
			user.password = Devise.friendly_token[0,20]
			user.full_name = auth.info.name   # assuming the user model has a name
			user.avatar = auth.info.image # assuming the user model has an image
			# If you are using confirmable and the provider(s) you use validate emails,
			# uncomment the line below to skip the confirmation emails.
			# user.skip_confirmation!
		end
	end

	def self.new_with_session(params, session)
		super.tap do |user|
			if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
				user.email = data["email"] if user.email.blank?
			end
		end
	end

	private
		def set_name
			if self.first_name.blank?
				self.update( first_name: self.email.split( /@/ ).first )
			end
		end

end
