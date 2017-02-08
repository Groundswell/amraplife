class Workout < ActiveRecord::Base
	
	enum status: { 'draft' => 0, 'active' => 1, 'archive' => 2, 'trash' => 3 }

	validates		:title, presence: true, unless: :allow_blank_title?

	attr_accessor	:slug_pref

	before_save	:set_publish_at

	include SwellMedia::Concerns::URLConcern
	include SwellMedia::Concerns::AvatarAsset
	include SwellMedia::Concerns::TagArrayConcern
	#include SwellMedia::Concerns::ExpiresCache


	has_many 	:workout_movements
	has_many 	:movements, through: :workout_movements
	has_many 	:equipment, through: :movements
	has_many 	:workout_segments

	mounted_at '/workouts'

	include FriendlyId
	friendly_id :slugger, use: [ :slugged, :history ]

	acts_as_taggable_array_on :tags


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

	def slugger
		if self.slug_pref.present?
			self.slug = nil # friendly_id 5.0 only updates slug if slug field is nil
			return self.slug_pref
		else
			return self.title
		end
	end

	def tags_csv
		self.tags.join(',')
	end

	def tags_csv=(tags_csv)
		self.tags = tags_csv.split(/,\s*/)
	end

	def to_s
		self.title
	end


	private
		def allow_blank_title?
			self.slug_pref.present?
		end

		def set_publish_at
			# set publish_at
			self.publish_at ||= Time.zone.now
		end


	
end
