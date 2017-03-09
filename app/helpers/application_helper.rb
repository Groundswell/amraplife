module ApplicationHelper

	def shopify_code( code )
		return nil if code.blank?
		json_string = code.match(/ui\.createComponent\('product'\, (\{(\n|.)*?)\}\)/).captures.first.strip.match(/options\: (\{(\n|.)*\})/).captures.first.strip

		json_addition = <<-JSON
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
	'afterRender': function(evt) {
		$('.buy-btn').trigger('afterRender.ui.shopify', { evt: evt, model: evt.model } )
	}
}
JSON

		new_json_string = json_string.sub( '"product": {', "\"product\": { \n#{json_addition.strip}," )

		code = code.sub( json_string, new_json_string )
		code = code.sub( "ShopifyBuy.UI.onReady(client).then(function (ui) {\n", "ShopifyBuy.UI.onReady(client).then(function (ui) {\n$(document).trigger('ready.ui.shopify', { ui: ui, client: client } )\n" )

	end


end
