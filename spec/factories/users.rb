require "faker"

FactoryGirl.define do
	factory :user do
		name { Faker::Name.first_name }
		lastname { Faker::Name.last_name }
		email { Faker::Internet.email }
		password 'secret'
		password_confirmation 'secret'

		factory :admin do
			admin true
		end

		factory :invalid_user do
			name nil
		end
	end
end