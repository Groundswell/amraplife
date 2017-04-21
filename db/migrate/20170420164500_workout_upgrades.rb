class WorkoutUpgrades < ActiveRecord::Migration
	def change
		add_column	:workout_movements, :workout_segment_id, :integer
		add_column	:workout_movements, :seq, :integer, default: 1
	end
end
