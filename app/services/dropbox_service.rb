class DropboxService
	REFRESH_TOKEN_PATH = File.join(Rails.root, 'private', 'token.yml')

	def self.get_refresh_token
		# 1. Get an authorization URL, requesting offline access type.
		authenticator = DropboxApi::Authenticator.new(ENV["PIGALLERY_APP_ID"], ENV["PIGALLERY_APP_SECRET"])
		url = authenticator.auth_code.authorize_url(token_access_type: 'offline')

		# 2. Log into Dropbox and authorize your app. You need to open the
		#    authorization URL in your browser.
		puts "enter token from #{url}"
		auth_code = STDIN.gets.chomp

		# 3. Exchange the authorization code for a reusable access token
		access_token = authenticator.auth_code.get_token(auth_code)
		save_token(access_token.to_hash)
	end

	def self.client
		unless File.exist?(REFRESH_TOKEN_PATH)
			get_refresh_token
		end

		# 1. Initialize an authenticator
		authenticator = DropboxApi::Authenticator.new(ENV["PIGALLERY_APP_ID"], ENV["PIGALLERY_APP_SECRET"])
		token_hash = load_token

		# 2. Retrieve the token hash you previously stored somewhere safe, you can use
		#    it to build a new access token.
		access_token = OAuth2::AccessToken.from_hash(authenticator, token_hash)

		# 3. You now have an access token, so you can initialize a client like you
		#    would normally:
		client = DropboxApi::Client.new(
		  access_token: access_token,
		  on_token_refreshed: lambda { |new_token_hash|
		    save_token(new_token_hash)
		  }
		)
	end

	def self.save_token(token_hash)
		File.write(REFRESH_TOKEN_PATH, token_hash.to_yaml)
	end

	def self.load_token
		YAML.load_file(REFRESH_TOKEN_PATH)
	end
end