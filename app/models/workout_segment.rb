class WorkoutSegment < ActiveRecord::Base

	before_save :initialize_fields
	before_save :insert_seq
	before_save :parse_content


	before_destroy :update_seqs_on_destroy

	belongs_to :workout
	has_many :workout_movements

	def formatted_duration
		sprintf( '%02d', self.duration / 60 ) + ':' + sprintf( '%02d', self.duration % 60 )
	end

	def full_title
		"#{self.seq} #{self.title}".strip
	end

	def max_movement_seq
		return 1 if self.workout_movements.empty?
		self.workout_movements.maximum( :seq ) + 1
	end

	def to_s
		self.content
	end


	private

		def initialize_fields
			if self.workout.workout_type.nil?
				self.workout.update( workout_type: self.segment_type )
			end

			self.to_record = 'time'
			self.to_record = 'reps' if self.segment_type == 'amrap'
			self.to_record = 'weight' if self.segment_type == 'strength'
		end

		def insert_seq
			max_seq = self.workout.workout_segments.maximum( :seq )
			if self.seq.nil?
				self.seq = max_seq + 1
			else
				self.workout.workout_segments.where( "seq >= :s", s: self.seq ).each do |segment|
					segment.update_column( :seq, segment.seq + 1 )
				end
			end
		end


		def parse_content
			self.total_reps = 0

			if self.segment_type == 'rest' && self.duration.nil?
				duration = 0
				# content should express duration
				# look for digits followed by non-digits
				matches = content.match( /([\d:]+)(\D+)/ )
				if matches.present?
					if matches.captures[0].match( /:/ )
						# duration entered in clock format e.g. '3:00'
						duration = ( matches.captures[0].split(':')[0] * 60 ) + matches.captures[0].split(':')[1].to+i
					else
						# assume duration entered as '4 mins' or '30 sec'
						# we don't account for blended case e.g. 30:00 minutes
						if matches.captures[1].match( /\Am/i )
							duration = matches.captures[0].to_i * 60
						elsif matches.captures[1].match( /\As/i )
							duration = matches.captures[0].to_i
						end
					end
				end
				self.duration = duration
			else
				# fancy-pants for getting reps, movements, and prescriptions out of the content
				self.content.each_line do |line|
					rep_match = line.match( /\A[\d\s]*/ )
					reps = rep_match.to_s.strip.split( /\s/ )
					if reps.size > 1
						reps = reps.inject(0){ |sum, i| sum + i.to_i }
					else reps.size == 1
						reps = reps.first.to_i
					end

					self.total_reps += reps

					movement_match = rep_match.post_match.match( /\A[^\d@rx]*/ ) # everything up to an @ or rx or a number
					movement = movement_match.to_s.strip

					rx = movement_match.post_match.split( '/' )
					m_rx = rx[0]
					if m_rx.present?
						m_rx.gsub!( '@', '' )
						m_rx.strip!
					end
					f_rx = rx[1]
					if f_rx.present?
						f_rx.strip!
					elsif m_rx.present?
						f_rx = m_rx
					end

					term = movement.downcase.singularize.gsub( /\s+/, '' )
					mov = Movement.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: term ).first || Movement.find_by_alias( term )
					if mov.present? && not( self.workout.workout_movements.include?( mov ) )
						self.workout.workout_movements.create( movement: mov, m_rx: m_rx, f_rx: f_rx )
					end
				end
			end
		end





		def update_seqs_on_destroy
			self.workout.workout_segments.where( "seq >= :s", s: self.seq ).each do |segment|
				segment.update_column( :seq, segment.seq - 1 )
			end
		end
end
