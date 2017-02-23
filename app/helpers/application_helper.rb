module ApplicationHelper

	def shopify_code( code )

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
}
JSON

		new_json_string = json_string.sub( '"product": {', "\"product\": { \n#{json_addition.strip}," )
		# new_json_string = new_json_string.sub( '"img": false', '"img": true' )


		code.sub( json_string, new_json_string )

	end


end
