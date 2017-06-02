# desc "Explaining what the task does"
namespace :utils do

	task update_assets: :environment do

		SwellMedia::Asset.where(parent_obj_type: 'Product').update_all( parent_obj_type: 'SwellEcom::Product' )

	end

	task ssl_avatars: :environment do

		SwellMedia::Media.update_all("avatar = replace(avatar, 'http:', 'https:'), cover_image = replace(cover_image, 'http:', 'https:')")
		SwellMedia::Category.update_all("avatar = replace(avatar, 'http:', 'https:'), cover_image = replace(cover_image, 'http:', 'https:')")
		Equipment.update_all("avatar = replace(avatar, 'http:', 'https:'), cover_image = replace(cover_image, 'http:', 'https:')")
		EquipmentModel.update_all("avatar = replace(avatar, 'http:', 'https:')")
		Food.update_all("avatar = replace(avatar, 'http:', 'https:'), cover_image = replace(cover_image, 'http:', 'https:')")
		Movement.update_all("avatar = replace(avatar, 'http:', 'https:'), cover_image = replace(cover_image, 'http:', 'https:')")
		Place.update_all("avatar = replace(avatar, 'http:', 'https:'), cover_image = replace(cover_image, 'http:', 'https:')")
		SwellEcom::ProductVariant.update_all("avatar = replace(avatar, 'http:', 'https:')")
		SwellEcom::Product.update_all("avatar = replace(avatar, 'http:', 'https:')")
		Recipe.update_all("avatar = replace(avatar, 'http:', 'https:'), cover_image = replace(cover_image, 'http:', 'https:')")
		User.update_all("avatar = replace(avatar, 'http:', 'https:'), cover_image = replace(cover_image, 'http:', 'https:')")
		Workout.update_all("avatar = replace(avatar, 'http:', 'https:'), cover_image = replace(cover_image, 'http:', 'https:')")

	end
end
