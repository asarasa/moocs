class WelcomeController < ApplicationController
	def index
		@users = User.desc(:register_date)
	end
end