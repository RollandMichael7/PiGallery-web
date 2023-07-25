namespace :pigallery do

  desc "Import data from Dropbox app"
  task import: :environment do
  	client = DropboxService.client

	ActiveRecord::Base.transaction do
		import_obj = nil

		# if month cant be found through EXIF, set to current month
		now = Time.zone.now
		month_name = now.strftime("%B")
		month_index = now.strftime("%m").to_i
		year = now.strftime("%Y").to_i
		now_month_obj = Month.find_or_create_by(year: year, month: month_name, month_index: month_index)

		cursor = client.list_folder("/jsons")
		cursor.entries.each do |entry|
			client.download(entry.path_display) do |content|				
				subject_hash = JSON.parse(content)
				subject_obj = Subject.find_or_initialize_by(name: subject_hash["name"], species: subject_hash["species"])
				
				# only update DB obj if hash has changed
				if subject_obj.content_hash != entry.content_hash
					puts "updating #{subject_obj.name}"
					import_obj = Import.create! if import_obj.nil?

					subject_obj.content_hash = entry.content_hash
					subject_obj.save!

					subject_hash["images"].each do |img_hash|
						content_hash = client.get_metadata(img_hash["photo"]).content_hash
						next if Image.find_by(content_hash: content_hash)

						img_obj = Image.find_or_initialize_by(app_path: img_hash["photo"])
						location_obj = Location.find_or_create_by!(name: img_hash["location"])
						month_obj = now_month_obj

						if location_obj.latitude.nil?
							location_obj.set_coords_from_geocode
						end

						file_name = File.basename(img_obj.app_path)

						# thumb_data = nil
						client.get_thumbnail(img_obj.app_path, format: :jpeg, size: :w640h480) do |thumbnail_content|
							file = File.new(File.join(Rails.root, 'app', 'assets', 'images', 'thumbs', file_name), "w")
							file.write(thumbnail_content)
							# thumb_data = thumbnail_content
						end

						# img_data = nil
						exif = nil
						begin
							client.download(img_obj.app_path) do |img_content|
								# img_data = img_content
								file = File.new(File.join(Rails.root, 'app', 'assets', 'images', file_name), "w")
								file.write(img_content)
								exif = Exif::Data.new(img_content)
							end
						rescue => error 
							puts "no EXIF data found"
						end

						# thumb_data = Base64.encode64(thumb_data)
						# thumbnail_b64 = "data:image/jpeg;base64,#{thumb_data}"
						# img_data = Base64.encode64(img_data)
						# img_b64 = "data:image/jpeg;base64,#{img_data}"

						if exif.present?
							date_taken =  DateTime.strptime(exif.date_time_original, "%Y:%m:%d %H:%M:%S")
							month_name = date_taken.strftime("%B")
							month_index = date_taken.strftime("%m").to_i
							year = date_taken.strftime("%Y").to_i

							month_obj = Month.find_or_create_by(year: year, month: month_name, month_index: month_index)
						end

						img_obj.update!({
							content_hash: content_hash,
							name_detail: img_hash["name_detail"],
							# thumbnail: thumbnail_b64,
							# image: img_b64,
							date_taken: exif.present? ? DateTime.strptime(exif.date_time_original, "%Y:%m:%d %H:%M:%S") : nil,
							camera_body: exif&.model,
							focal_length: exif&.focal_length,
							aperture: exif&.fnumber,
							iso: exif&.iso_speed_ratings,
							shutter: exif&.exposure_time,
							subject_id: subject_obj.id,
							location_id: location_obj.id,
							month_id: month_obj.id,
							import_id: import_obj.id,
						})
					end
				end
			end
		end
	end

	puts "all done"
  end
end