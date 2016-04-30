require 'rails_helper'

RSpec.describe Wiki, type: :model do

  describe "attributes" do
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:body).of_type(:text) }
    it { should have_db_column(:private).of_type(:boolean).with_options({default: false, null: false}) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title)}
    it { is_expected.to validate_presence_of(:body)}
    it { is_expected.to validate_length_of(:title).is_at_least(5)}
    it { is_expected.to validate_length_of(:body).is_at_least(15)}
  end

end
