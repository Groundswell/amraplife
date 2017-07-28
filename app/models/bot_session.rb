class BotSession < ActiveRecord::Base

	belongs_to :user

	def self.find_or_initialize_for( args = {} )
		provider = args[:provider]
		uid = args[:uid]
		user = args[:user]

		bot_session = BotSession.where( provider: provider, uid: uid ).first_or_initialize

		if bot_session.user.present? && bot_session.user != user
			bot_session = BotSession.where( provider: provider, uid: uid, user: user ).first_or_initialize
		else
			bot_session.user = user
		end

		bot_session
	end

	def self.cull( args = {} )
		max_age = args[:max_age] || 1.day
		BotSession.where( 'updated_at < ?', max_age.ago ).destroy_all
	end

	def save_if_used
		if self.persisted? || self.properties.present?
			self.save
		end
	end

	def add_session_attribute( key, value )
		self.properties = self.properties.merge( key.to_s => value )
	end

	def get_session_attribute( key )
		self.properties[key.to_s]
	end

end
