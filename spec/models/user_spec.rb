require 'rails_helper'

RSpec.describe User, type: :model do


  describe "attributes" do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:role).of_type(:integer) }
    it { should define_enum_for(:role) }
    it { is_expected.to respond_to(:admin?) }
    it { is_expected.to respond_to(:standard?) }
    it { is_expected.to respond_to(:premium?) }
  end

  describe "associations" do
    it { should have_many(:wikis) }
    it { should have_many(:collaborations)}
    it { should have_many(:shared_wikis).through(:collaborations).source(:wiki) }
  end

  describe "validations" do
    #name
    it { is_expected.to validate_presence_of(:name)}
    it { is_expected.to validate_length_of(:name).is_at_least(4)}
    it { should validate_uniqueness_of(:name).case_insensitive }
    #password
    it { is_expected.to validate_presence_of(:password)}
    it { is_expected.to validate_length_of(:password).is_at_least(6)}
    #email
    it { is_expected.to validate_length_of(:email).is_at_least(3)}
    it { is_expected.to allow_value("user@blocipedia.com").for(:email)}
    it { is_expected.to validate_presence_of(:email)}
    it { should validate_uniqueness_of(:email).case_insensitive }
    #role
    it { is_expected.to validate_presence_of(:role)}
  end

  describe "after_create" do
    before do
      @user = User.new(name: 'FEFelson', email: 'edwrdwalsh@gmail.com', password: 'password', role: :standard)
    end

    it "sends an email to users who have signed up" do
      expect(UserMailer).to receive(:new_user).with(@user).and_return(double(deliver_now: true))
      @user.save!
    end
  end

  describe 'collaborations' do
    before do
      @user = create(:user)
      @other_user = create(:user)
      @wiki = create(:wiki, user: @other_user)
    end

    it "returns 'nil' if the user has no shared wikis" do
      expect(@user.shared_wikis).to be_empty
    end

    it "returns the shared wikis if they exist" do
      @user.shared_wikis << @wiki
      expect(@user.shared_wikis).to eq([@wiki])
    end
  end

end
