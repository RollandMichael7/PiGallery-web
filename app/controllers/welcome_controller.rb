class WelcomeController < ApplicationController
	def index
		@subject_images = Subject.all.sample(10).map { |s| {image: s.images.first.thumbnail_path, caption: s.name, link: subject_path(s) } }
		@subject_count = Subject.count

		@location_images = Location.all.sample(10).map { |l| {image: l.images.first.thumbnail_path, caption: l.name, link: location_path(l) } }
		@location_count = Location.count

		@month_images = Month.all.sample(10).map { |m| {image: m.images.first.thumbnail_path, caption: "#{m.month} #{m.year}", link: month_path(m) } }
		@month_count = Month.count
	end
end