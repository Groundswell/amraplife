$( document ).ready ->
	setTimeout (->
		$('.sidebar-scroll-nav').each ()->
			$nav = $(this)
			$nav.affix(
				offset: {
					top: ->
						# c = $nav.offset().top
						#d = parseInt($nav.children(0).css('margin-top'), 10)
						headerBottom = $('.main-wrapper>.header').height()
						$nav.css('top', headerBottom)
						@top = headerBottom
					# bottom: ->
					# 	@bottom = $('.main-wrapper>.footer').outerHeight(!0)
				}
			)
	), 100

	$('form.submit-once').submit ->
		$form = $(this)
		setTimeout (->
			$form.children('input[type=submit]').addClass('disabled');
		), 50
		return false;
