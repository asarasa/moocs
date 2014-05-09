# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer, :class => 'Answers' do
    answer "MyText"
    valid false
  end
end
