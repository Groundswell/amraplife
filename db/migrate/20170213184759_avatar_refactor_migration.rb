class AvatarRefactorMigration < ActiveRecord::Migration
	def change

		add_column :equipment, :cover_image, :text
		add_column :foods, :cover_image, :text
		add_column :movements, :cover_image, :text
		add_column :places, :cover_image, :text
		add_column :recipes, :cover_image, :text
		add_column :products, :cover_image, :text
		add_column :skus, :cover_image, :text

		rename_column :media, :cover_path, :cover_image

		change_column :media, :cover_image, :text
		change_column :media, :avatar, :text

		change_column :users, :cover_image, :text
		change_column :users, :avatar, :text

		change_column :categories, :cover_image, :text
		change_column :categories, :avatar, :text

		change_column :card_designs, :avatar, :text

		change_column :products, :avatar, :text
		change_column :skus, :avatar, :text

		rename_column :workouts, :cover_img, :cover_image
		change_column :workouts, :cover_image, :text
		change_column :workouts, :avatar, :text

		change_column :movements, :avatar, :text

		change_column :places, :avatar, :text

		change_column :recipes, :avatar, :text

		change_column :equipment, :avatar, :text
		change_column :foods, :avatar, :text

	end
end
