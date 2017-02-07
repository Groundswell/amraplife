class Workout < ActiveRecord::Base
	
	enum status: { 'draft' => 0, 'active' => 1, 'archive' => 2, 'trash' => 3 }
	before_save	:set_publish_at

	has_many 	:workout_movements
	has_many 	:movements, through: :workout_movements
	has_many 	:equipment, through: :movements
	has_many 	:workout_segments


	include FriendlyId
	friendly_id :title, use: [ :slugged, :history ]




	def self.published( args = {} )
		where( "publish_at <= :now", now: Time.zone.now ).active
	end



	def human_type
		if self.workout_type == 'ft'
			return "For Time"
		elsif self.workout_type == 'rft'
			return "Rounds For Time"
		elsif self.workout_type == 'amrap'
			return 'As Many Reps As Possible'
		elsif self.workout_type == 'emom'
			int = self.workout_segments.first.repeat_interval / 60
			min = int > 1 ? 'Minutes' : 'Minute'
			return "Every #{int} #{min} on the Minute"
		elsif self.workout_type == 'tabata'
			return "TABATA"
		else
			return "Custom"
		end
	end

	def max_segment_seq
		return 1 if self.workout_segments.empty?
		self.workout_segments.maximum( :seq ) + 1
	end

	def overview_title
		if self.workout_type == 'ft'
			return "For Time:"
		elsif self.workout_type == 'rft'
			return "#{self.workout_segments.first.repeat_count} Rounds For Time"
		elsif self.workout_type == 'amrap'
			return "As Many Reps As Possible in\n #{self.workout_segments.first.formatted_duration} Minutes"
		elsif self.workout_type == 'emom'
			int = self.workout_segments.first.repeat_interval / 60
			min = int > 1 ? 'Minutes' : 'Minute'
			return "Every #{int} #{min} on the Minute"
		elsif self.workout_type == 'tabata'
			return "TABATA This"
		else
			return "Custom"
		end
	end

	def overview_content
		self.workout_segments.pluck( :content ).join( "\r\n" )
	end

	def to_s
		self.title
	end


	private
		def set_publish_at
			# set publish_at
			self.publish_at ||= Time.zone.now
		end


	
end
