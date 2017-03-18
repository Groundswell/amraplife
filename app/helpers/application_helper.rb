module ApplicationHelper

	def shopify_code( code )
		return nil if code.blank?
		json_string = code.match(/ui\.createComponent\('product'\, (\{(\n|.)*?)\}\)/).captures.first.strip.match(/options\: (\{(\n|.)*\})/).captures.first.strip

		puts json_string

		product_json_addition = <<-JSON
DOMEvents: {
  'change [data-element="option.select"]': function (evt, target) {
	  product_id = parseInt( (target.ownerDocument.defaultView || target.ownerDocument.parentWindow).name.replace('frame-product-','') )
	  var product = ui.components.product.filter(function (product) {
		  return product.id[0] == product_id;
	  })[0];

	  $('.buy-btn').trigger('change.option', { option: $(target).attr('name'), value: $( target ).val() || $( "option:selected", target ).text(), ui: product } )
  }
},
events: {
	'afterRender': function(evt) { $('.buy-btn').trigger('afterRender.ui.shopify', { evt: evt, model: evt.model, ui: ui } ) },
	'addVariantToCart': function(evt) { $('.buy-btn').trigger('addVariantToCart.ui.shopify', { evt: evt, model: evt.model, ui: ui } ) },
	'updateQuantity': function(evt) { $('.buy-btn').trigger('updateQuantity.ui.shopify', { evt: evt, ui: ui } ) },
	'openModal': function(evt) { $('.buy-btn').trigger('openModal.ui.shopify', { evt: evt, ui: ui } ) },
	'openOnlineStore': function(evt) { $('.buy-btn').trigger('openOnlineStore.ui.shopify', { evt: evt, ui: ui } ) },
	'openCheckout': function(evt) { $('.buy-btn').trigger('openCheckout.ui.shopify', { evt: evt, ui: ui } ) },
	'closeModal': function(evt) { $('.buy-btn').trigger('closeModal.ui.shopify', { evt: evt, ui: ui } ) }
}
JSON

		cart_json_addition = <<-JSON
DOMEvents: {
  'click button': function (evt, target) { $('.buy-btn').trigger('clickCheckout.ui.shopify', { evt: evt, ui: ui } ) }
},
"events": {
	'openCheckout': function(cart) {
		$('.buy-btn').trigger('openCheckout.ui.shopify', { cart: evt, ui: ui } )
	},
	'updateItemQuantity': function(cart) { $('.buy-btn').trigger('updateItemQuantity.ui.shopify', { cart: evt, ui: ui } ) }
}
JSON

		new_json_string = json_string.sub( '"product": {', "\"product\": { \n#{product_json_addition.strip}," )
		new_json_string = new_json_string.sub( '"cart": {', "\"cart\": { \n#{cart_json_addition.strip}," )

		code = code.sub( json_string, new_json_string )
		code = code.sub( "ShopifyBuy.UI.onReady(client).then(function (ui) {\n", "ShopifyBuy.UI.onReady(client).then(function (ui) {\n$(document).trigger('ready.ui.shopify', { ui: ui, client: client } )\n" )

	end


end
