
class WorkoutAdminController < SwellMedia::AdminController 
	before_action :set_workout, only: [:show, :edit, :update, :destroy]

	def create
		@workout = Workout.new( workout_params )
		@workout.save 
		redirect_to edit_workout_admin_path( @workout )
	end

	def destroy
		@workout.destroy
		redirect_to workouts_url
	end

	def edit
		set_page_meta( title: "Edit #{@workout} )°( Live AMRAP" )
		# if @workout.workout_type == 'amrap'
		# 	@segment = @workout.workout_segments.first || WorkoutSegment.new( duration: 0 )
		# 	@segment.duration = @segment.formatted_duration
		# 	render 'edit_amrap'
		# end
		# if @workout.workout_type == 'rft'
		# 	@segment = @workout.workout_segments.first || WorkoutSegment.new()
		# 	render 'edit_rft'
		# end
		# if @workout.workout_type == 'ft'
		# 	render 'edit_ft'
		# end
		# if @workout.workout_type == 'eotm'
		# 	@segment = @workout.workout_segments.first || WorkoutSegment.new( every_interval: 1 )
		# 	render 'edit_eotm'
		# end
		
	end

	def index
		by = params[:by] || 'title'
		dir = params[:dir] || 'asc'
		@workouts = Workout.order( "#{by} #{dir}" )
		if params[:q]
			match = params[:q].downcase.singularize.gsub( /\s+/, '' )
			@workouts = @workouts.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match )
			@workouts << Workout.find_by_alias( match )
		end
		@workout_count = @workouts.count
		@workouts = @workouts.page( params[:page] )
		
	end

	def update
		@workout.update( workout_params )
		redirect_to :back
	end


	private
		def workout_params
			params.require( :workout ).permit( :title, :description, :content, :workout_type, :status, :tags_csv, :slug_pref ) 	
		end

		def set_workout
			@workout = Workout.friendly.find( params[:id] )
		end
end