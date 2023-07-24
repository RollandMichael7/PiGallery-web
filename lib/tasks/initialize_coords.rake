namespace :pigallery do

	desc "Initialize coordinates for locations"
	task initialize_coords: :environment do
		ActiveRecord::Base.transaction do
			Location.all.each do |location|
				next unless location&.name

				puts(location.name)
				location.set_coords_from_geocode
			end
		end

		puts "all done"
	end
end