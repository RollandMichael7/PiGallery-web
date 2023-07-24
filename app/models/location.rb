class Location < ApplicationRecord
	has_many :images
	has_many :subjects, -> { distinct }, through: :images
	has_many :months, -> { distinct }, through: :images
	has_many :imports, -> { distinct }, through: :images

	validates :name, uniqueness: true

	def set_coords_from_geocode(geocode = nil)
		geocode ||= self.name

		coords = Google::Maps.geocode(geocode).first
		self.update!({
			latitude: coords.latitude,
			longitude: coords.longitude,
		})
	end

	def month_range
		ordered_months = self.months.order(:year, :month_index)

		{
			from: ordered_months.first.name,
			to: ordered_months.last.name,
		}
	end
end