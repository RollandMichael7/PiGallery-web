namespace :pigallery do

	desc "Initialize month for images"
	task initialize_months: :environment do
		ActiveRecord::Base.transaction do
			Image.all.each do |image|
				next unless image&.date_taken
				
				month_name = image.date_taken.strftime("%B")
				month_index = image.date_taken.strftime("%m").to_i
				year = image.date_taken.strftime("%Y").to_i

				month = Month.find_or_create_by(year: year, month: month_name, month_index: month_index)
				image.update!(month: month)
			end
		end

		puts "all done"
	end
end