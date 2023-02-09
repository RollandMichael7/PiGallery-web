class Import < ApplicationRecord
	has_many :images
	has_many :locations, -> { distinct }, through: :images
	has_many :subjects, -> { distinct }, through: :images
end