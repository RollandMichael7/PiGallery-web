class Image < ApplicationRecord
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
end