$( document ).ready ->
	$('.img-group').magnificPopup delegate: 'a', type: 'image', gallery: { enabled:true, navigateByImgClick: true }

	$('.grid').each ()->
		$grid = $(this)
		$grid.imagesLoaded ()->
			$('.grid').masonry({
				itemSelector: '.grid-item',
				columnWidth: '.grid-item'
			});
