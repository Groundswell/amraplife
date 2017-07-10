
class Assignment < ActiveRecord::Base

	enum availability: { 'just_me' => 0, 'trainer' => 1, 'team' => 3, 'community' => 5, 'anyone' => 10 }

	belongs_to 	:assinged, polymorphic: true
	belongs_to 	:user
	belongs_to 	:assigned_by, class_name: 'User'


end