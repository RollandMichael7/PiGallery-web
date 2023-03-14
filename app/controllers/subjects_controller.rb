class SubjectsController < ApplicationController
	def index
		@subjects = Subject.order(:name)
		@subjects = apply_search(@subjects)

		@subjects = @subjects.page(params[:page]).per(15)
	end

	def show
		@subject = Subject.find(params[:id])

		page_size = browser.device.mobile? ? 10 : 5
		@images = @subject.images.order(date_taken: :desc).page(params[:page]).per(page_size)
	end

	private

	def apply_search(subjects)
		search = params[:search]

		if search.present?
			subjects = subjects.joins(images: :location).where(
				"lower(subjects.name) LIKE :search OR lower(locations.name) LIKE :search",
				{ search: "%#{search}%" },
			).distinct
		end

		return subjects
	end
end