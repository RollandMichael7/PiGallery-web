class WelcomeController < ApplicationController
	ICON_CLASS = " fa-2x"

	def index
		@summaries = [subject_summary, location_summary, month_summary]
	end

	private

	def subject_summary
		images = Subject.all.sample(10).map { |s| {image: s.images.sample.thumbnail_path, caption: s.name, link: subject_path(s) } }
		count = Subject.count

		{
			link: "/subjects",
			icon: CONFIG[:sidebar_items][:subjects][:icon] + ICON_CLASS,
			title: "<span>Explore <b>#{count}</b> species</span>",
			description: "",
			images: images,
		}
	end

	def location_summary
		images = Location.all.sample(10).map { |s| {image: s.images.sample.thumbnail_path, caption: s.name, link: location_path(s) } }
		count = Location.count

		{
			link: "/map",
			icon: CONFIG[:sidebar_items][:locations][:icon] + ICON_CLASS,
			title: "<span>in <b>#{count}</b> locations</span>",
			description: "",
			images: images,
		}
	end

	def month_summary
		images = Month.order({year: :desc, month_index: :desc }).first(10).map { |m| {image: m.images.sample.thumbnail_path, caption: "#{m.month} #{m.year}", link: month_path(m) } }
		count = Month.count

		{
			link: "/months",
			icon: CONFIG[:sidebar_items][:months][:icon] + ICON_CLASS,
			title: "<span>over <b>#{count}</b> months</span>",
			description: "",
			images: images,
		}
	end
end