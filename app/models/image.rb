class Image < ApplicationRecord
	NAME_DETAIL_JUVENILE = "j.".freeze
	NAME_DETAIL_FEMALE = "f.".freeze
	NAME_DETAIL_MALE = "m.".freeze
	NAME_DETAIL_CAPTIVE = "captive".freeze

	FULL_NAME_DETAILS = {
		NAME_DETAIL_JUVENILE => "Juvenile",
		NAME_DETAIL_MALE => "Male",
		NAME_DETAIL_FEMALE => "Female",
	}

	belongs_to :subject
	belongs_to :location
	belongs_to :month
	belongs_to :import

	validates :app_path, uniqueness: true

	def file_name
		File.basename(self.app_path)
	end

	def thumbnail_path
		File.join('thumbs', file_name)
	end

	def image_path
		File.join(Rails.root, 'app', 'assets', 'images', file_name)
	end

	def full_name_detail
		name_details = self.name_detail&.split(",")&.map do |detail|
			detail = detail.strip
			detail = FULL_NAME_DETAILS[detail.downcase] || detail
		end

		name_details&.join(", ")
	end
end