
class StatsController < ApplicationController

	before_filter :authenticate_user!

	layout 'dash'

	def index
		@stat = current_user.metrics.friendly.find( params[:stat] ) if params[:stat].present?
		@stat ||= current_user.metrics.first

		@comp_stat = current_user.metrics.friendly.find( params[:comp_stat] ) if params[:comp_stat].present?

		@start_date = 30.days.ago.beginning_of_day
		@end_date = Time.zone.now.end_of_day
		if params[:start_date].present? && params[:end_date].present?
			@start_date = Date.strptime( params[:start_date], '%m/%d/%Y' ).beginning_of_day
			@end_date = Date.strptime( params[:end_date], '%m/%d/%Y' ).end_of_day
		end

		@chart_data = current_user.observations.for( @stat ).dated_between( @start_date, @end_date )

		if @comp_stat.present?
			@comp_data = current_user.observations.for( @comp_stat ).dated_between( @start_date, @end_date )
		end

		if params[:normalize].present?
			minA = @chart_data.minimum( :value ) < @comp_data.minimum( :value ) ? @chart_data.minimum( :value ) : @comp_data.minimum( :value )
			maxB = @chart_data.maximum( :value ) > @comp_data.maximum( :value ) ? @chart_data.maximum( :value ) : @comp_data.maximum( :value )

			@chart_data.each{ |point| point.value = 1+(point.value-@chart_data.minimum( :value ))*9/(@chart_data.maximum( :value )-@chart_data.minimum( :value )) }
			@comp_data.each{ |point| point.value = 1+(point.value-@comp_data.minimum( :value ))*9/(@comp_data.maximum( :value )-@comp_data.minimum( :value )) }
		end
	end


	def show
		@stat = current_user.metrics.friendly.find( params[:id] )

		@start_date = 30.days.ago.beginning_of_day
		@end_date = Time.zone.now.end_of_day
		if params[:start_date].present? && params[:end_date].present?
			@start_date = Date.strptime( params[:start_date], '%m/%d/%Y' ).beginning_of_day
			@end_date = Date.strptime( params[:end_date], '%m/%d/%Y' ).end_of_day
		end

		@observations = current_user.observations.for( @stat ).dated_between( @start_date, @end_date )

		@stat_vector = Daru::Vector.new( @observations.pluck( :value ) )
	end

end
