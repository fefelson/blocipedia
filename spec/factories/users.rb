FactoryGirl.define do
  pw = RandomData.random_sentence

  factory :user do
    sequence(:name) {|n|"#{n}#{RandomData.random_word}"}
    sequence(:email){|n| "user#{n}@factory.com"}
    password pw
    password_confirmation pw
    role :standard
  end
end
