require 'rails_helper'

RSpec.describe Wiki, type: :model do

  describe "attributes" do
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:body).of_type(:text) }
    it { should have_db_column(:private).of_type(:boolean).with_options({default: false, null: false}) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:collaborations) }
    it { should have_many(:users).through(:collaborations)}
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title)}
    it { is_expected.to validate_presence_of(:body)}
    it { is_expected.to validate_length_of(:title).is_at_least(5)}
    it { is_expected.to validate_length_of(:body).is_at_least(15)}
  end

  describe 'collaborations' do
    before do
      @user = create(:user)
      @wiki = create(:wiki, user: @user)
      @other_user = create(:user)
    end

    it "returns 'nil' if the wiki has no collaborators" do
      expect(@wiki.users).to be_empty
    end

    it "returns the users if they exist" do
      @wiki.users << @other_user
      expect(@wiki.users).to eq([@other_user])
    end
  end

end
