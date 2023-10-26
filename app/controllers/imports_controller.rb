class ImportsController < ApplicationController
	def index		
		@imports = Import.all.order("date(imports.created_at) DESC")
		@imports = apply_search(@imports)

		@imports = @imports.page(params[:page]).per(15)
	end

	def show
		@import = Import.find(params[:id])

		page_size = browser.device.mobile? ? 10 : 5
		@images = @import.images.order(:date_taken).page(params[:page]).per(page_size)
	end

	private

	def apply_search(imports)
		search = params[:search]

		if search.present?
			imports = imports.joins(images: [:location, :subject]).where(
				"lower(subjects.name) LIKE :search OR lower(locations.name) LIKE :search",
				{ search: "%#{search}%" },
			).distinct
		end

		return imports
	end
end