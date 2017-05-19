$( document ).ready ->
	$(window).scroll ->
		didScroll = true

		setInterval( ->
			if didScroll
				didScroll = false
				$(window).trigger('scroll.amraplife')
		, 250);

	$(window).on 'scroll.amraplife', ()->
		window_page = $(window).scrollTop() / $(window).height()
		# $('body').attr("class", ($('body').attr("class") || '').replace(/\s*window\-page\-\d+(\-plus)?/,'') ).addClass('window-page-'+Math.floor(window_page))
		if window_page >= 0.25
			$('body').addClass('window-page-0_25-plus')
		else
			$('body').removeClass('window-page-0_25-plus')

		if window_page >= 0.5
			$('body').addClass('window-page-0_5-plus')
		else
			$('body').removeClass('window-page-0_5-plus')

		if window_page >= 1
			$('body').addClass('window-page-1-plus')
		else
			$('body').removeClass('window-page-1-plus')
