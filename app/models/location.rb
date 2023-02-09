class Location < ApplicationRecord
	has_many :images
	has_many :subjects, -> { distinct }, through: :images

	validates :name, uniqueness: true
end