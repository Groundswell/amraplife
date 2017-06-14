
ready = $ ->

	if $('#activity_recurs').val() is 'never' or $('#activity_recurs').val() is 'daily'
		$('#day_select').css( 'display', 'none' )

	if $('#activity_recurs').val() is 'weekly'
		$('#monthly_select').css( 'display', 'none' )
	else
		$('#weekly_select').css( 'display', 'none' )

	
	$('#datepickerDateRange').daterangepicker(); # { format: 'MM/DD/YYYY' } 

	$('.datepicker').datepicker
		format: 'mm/dd/yyyy'

	$('.datetimepicker').datetimepicker();


	$('#activity_recurs').change ->
		if $(@).val() is 'weekly'
			$('#day_select').show( 500 )
			$('#monthly_select').hide()
			$('#weekly_select').show()
		else if $(@).val() is 'monthly'
			$('#day_select').show( 500 )
			$('#weekly_select').hide()
			$('#monthly_select').show()
		else
			$('#day_select').hide( 500 )

	$('.feed li').click ->
		$(@).children('.comment-form').show( 500 )

	$('.cancel-comment').click ->
		$(@).parents('.comment-form').hide( 500 )
		return false