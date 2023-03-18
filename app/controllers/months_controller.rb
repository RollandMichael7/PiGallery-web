class MonthsController < ApplicationController
	def index
		@months = Month.order(:year, :month_index)
		@months = apply_search(@months)

		@months = @months.page(params[:page]).per(15)
	end

	def show
		@month = Month.find(params[:id])

		page_size = browser.device.mobile? ? 10 : 5
		@images = @month.images.order(date_taken: :desc).page(params[:page]).per(page_size)
	end

	private

	def apply_search(months)
		search = params[:search]

		if search.present?
			months = months.joins(images: :subject).where(
				"lower(months.month) LIKE :search OR months.year LIKE :search OR lower(subjects.name) LIKE :search",
				{ search: "%#{search}%" },
			).distinct
		end

		return months
	end
end