class LocationsController < ApplicationController
	def index
		@locations = Location.order(:name)
		@locations = apply_search(@locations)

		@locations = @locations.page(params[:page]).per(15)
	end

	def show
		@location = Location.find(params[:id])

		page_size = browser.device.mobile? ? 10 : 5
		@images = @location.images.page(params[:page]).per(page_size)
	end

	private

	def apply_search(locations)
		search = params[:search]

		if search.present?
			locations = locations.where(
				"lower(name) LIKE :search",
				{ search: "%#{search}%" },
			).distinct
		end

		return locations
	end
end