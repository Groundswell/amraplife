$( document ).ready ->
	$('.img-group').magnificPopup delegate: 'a', type: 'image', gallery: { enabled:true, navigateByImgClick: true }

	$('.grid').each ()->
		$grid = $(this)
		$grid.imagesLoaded ()->
			$('.grid').masonry({
				itemSelector: '.grid-item',
				columnWidth: '.grid-item'
			});

	$(document).on 'change.option', '.buy-btn', (e, change)->
		# if window.console && console.log
		#	console.log 'change.option', e, change
		#	console.log change.ui.currentImage.src
		#	console.log change.ui.formattedPrice
		$('.product-show .price-info .price').html(change.ui.formattedPrice+' ')
		$('.product-show .img-group a').attr('href', change.ui.currentImage.src)
		$('.product-show .img-group a img').attr('src', change.ui.currentImage.src)
