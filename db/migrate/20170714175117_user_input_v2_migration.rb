class UserInputV2Migration < ActiveRecord::Migration
	def change
		rename_column :user_inputs, :created_obj_id, :result_obj_id
		rename_column :user_inputs, :created_obj_type, :result_obj_type

		add_field 	:user_inputs, :source, :string # web, mobile, fb, sack, alexa, goog_assistant
		add_field 	:user_inputs, :action, :string, default: :created # created, updated
		add_field 	:user_inputs, :system_notes, :text

	end
end
