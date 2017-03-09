$( document ).ready ->
	$('.grid').each ()->
		$grid = $(this)
		$grid.imagesLoaded ()->
			$('.grid').masonry({
				itemSelector: '.grid-item',
				columnWidth: '.grid-item'
			});

	$(document).on 'change.option', '.buy-btn', (e, change)->

		$( change.ui.carouselImages ).each (index,image)->
			if image.isSelected
				console.log image.src
				$('[data-shopify-carousel='+image.position+']').click()

		$('.product-show .price-info .price').html(change.ui.formattedPrice+' ')

	$(document).on 'afterRender.ui.shopify', '.buy-btn', (e, options)->
		return if $(this).data( 'ui.shopify' )
		$(this).data( 'ui.shopify', options.evt )
		console.log( 'afterRender.ui.shopify', e, options.evt.carouselImages )

		if options.evt.carouselImages.length > 1
			# add shopify images to carousel
			$( options.evt.carouselImages ).each (index, image)->
				if image.variant_ids.length > 0
					$image = $('<a href="#" data-zoom-image="'+image.src+'" data-image="'+image.src+'"><img src="'+image.carouselSrc+'" data-shopify-carousel="'+image.position+'" /></a>')
					$('.gallery').append $image

			$('.zoom-gallery').removeClass('hide-gallery') if $('.gallery>a').length > 1

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
