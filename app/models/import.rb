class Import < ApplicationRecord
	has_many :images
	has_many :locations, -> { distinct }, through: :images
	has_many :subjects, -> { distinct }, through: :images

	def new?
		created_at >= (Time.zone.now - CONFIG[:new_period_days].days)
	end
end