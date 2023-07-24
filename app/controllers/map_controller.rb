class MapController < ApplicationController
	def index
	end

	def coordinates
		coordinates = Location.all.map do |location|
			{
				id: location.id,
				name: location.name,
				image: ActionController::Base.helpers.asset_path(location.images.sample.thumbnail_path),
				latitude: location.latitude,
				longitude: location.longitude,
				month_range: location.month_range,
			}
		end

		render json: coordinates
	end
end