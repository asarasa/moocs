require "faker"

FactoryGirl.define do
	factory :member do
		association :user
		association :course

    factory :student do
      type 'student'
    end		

    factory :teacher do
      type 'teacher'
    end		

		date { DateTime.now }
	end
end