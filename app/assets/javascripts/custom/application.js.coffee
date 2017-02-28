$( document ).ready ->
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


	#initiate the plugin and pass the id of the div containing gallery images
	$('.zoom-gallery').each ->
		$container = $(this)
		$gallery = $('.gallery', $gallery)
		$img = $('img[data-zoom-image]',$container)

		$gallery.attr('id', 'zoom-gallery-'+( Math.floor(Math.random() * 10000) + Date.now() ) ) unless $gallery.attr('id')

		$img.elevateZoom(
			# constrainType: 'height'
			# constrainSize: 274
			zoomType: 'lens'
			containLensZoom: true
			gallery: $gallery.attr('id')
			cursor: 'pointer'
			galleryActiveClass: 'active'
		)

		#pass the images to Fancybox
		$img.bind 'click', (e) ->
			ez = $img.data('elevateZoom')
			$.fancybox ez.getGalleryList()
			false
