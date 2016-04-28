FactoryGirl.define do
  factory :wiki do
    title RandomData.random_word
    body RandomData.random_paragraph
    private false
    user
  end
end
