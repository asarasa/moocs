require "faker"

FactoryGirl.define do
	factory :course do
		name { Faker::Lorem.words }
		abstract { Faker::Lorem.paragraphs(1) }
		desc { Faker::Lorem.paragraphs }
		start_date { DateTime.now }
		end_date { DateTime.now + 30 }
	end
end