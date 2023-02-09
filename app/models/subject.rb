class Subject < ApplicationRecord
	has_many :images, dependent: :destroy
	has_many :locations, -> { distinct }, through: :images
	has_many :imports, -> { distinct }, through: :images

	validates :name, uniqueness: true
	validates :species, uniqueness: true

	accepts_nested_attributes_for :images
end