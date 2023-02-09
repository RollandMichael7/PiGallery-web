class RandomController < ApplicationController
	def index
		random_obj = (Subject.all + Location.all + Month.all).sample
		controller = random_obj.class.to_s.downcase.pluralize
		redirect_to "/#{controller}/#{random_obj.id}" 
	end
end