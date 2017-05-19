atom_feed( language: 'en-US', url: @url ) do |feed|
	feed.title @title
	feed.updated @results.first.created_at

	@results.each do |result|
		feed.entry result, {published: result.created_at, updated: result.updated_at} do |entry|
			entry.title result.title

			if ( img = (result.try(:avatar) || result.try(:cover_img)) ).present?
				entry.content "<img src='#{img}'/><p>#{(result.try(:content_preview) || result.try(:description_preview) || result.try(:sanitized_description) || result.try(:sanitized_description) || '').truncate(150)}</p>", type: 'html'
			else
				entry.content "<p>#{(result.try(:content_preview) || result.try(:description_preview) || result.try(:sanitized_description) || result.try(:sanitized_description) || '').truncate(150)}</p>", type: 'html'
			end
			entry.author do |author|
				author.name (result.try(:user).try(:full_name) || 'AMRAPLife')
			end
			entry.url result.url
			entry.summary (result.try(:content_preview) || result.try(:description_preview) || result.try(:sanitized_description) || result.try(:sanitized_description) || '').truncate(150)
		end
	end
end
