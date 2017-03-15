
class InspirationAdminController < SwellMedia::AdminController
	before_action :set_inspiration, only: [:show, :edit, :preview, :update, :destroy]

	def create
		@inspiration = Inspiration.new( inspiration_params )
		@inspiration.save
		redirect_to edit_inspiration_admin_path( @inspiration )
	end

	def destroy
		@inspiration.destroy
		redirect_to inspirations_url
	end

	def index
		by = params[:by] || 'title'
		dir = params[:dir] || 'asc'
		@inspirations = Inspiration.order( "#{by} #{dir}" )
		if params[:q]
			match = params[:q].downcase.singularize.gsub( /\s+/, '' )
			@inspirations = @inspirations.where( "lower(REGEXP_REPLACE(title, '\s', '' )) = :m", m: match )
			@inspirations << Inspiration.find_by_alias( match )
		end
		@inspiration_count = @inspirations.count
		@inspirations = @inspirations.page( params[:page] )

	end

	def preview
		@media = @inspiration
		set_page_meta( @inspiration.page_meta )
		render "swell_media/pages/show", layout: 'application'
	end

	def update
		@inspiration.update( inspiration_params )
		redirect_to :back
	end


	private
		def inspiration_params
			params.require( :inspiration ).permit( :title, :subtitle, :slug_pref, :description, :content, :status, :publish_at, :show_title, :is_commentable, :user_id, :tags, :tags_csv, :avatar, :avatar_asset_file, :avatar_asset_url )	
		end

		def set_inspiration
			@inspiration = Inspiration.friendly.find( params[:id] )
		end
end
