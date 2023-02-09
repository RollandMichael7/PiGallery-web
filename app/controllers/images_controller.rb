class ImagesController < ApplicationController
	def show
		@image = Image.find(params[:id])
		redirect_to @image.file_name
	end
end