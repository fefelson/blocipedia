require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:my_user) { create(:user)}

  context "guest" do

    describe "GET show" do
      it "returns http redirect" do
        get :show, {id: my_user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "standard user" do
    before do
      sign_in(my_user)
      my_user.confirm
    end

    describe "GET show" do
      it "returns http success" do
        get :show, { id: my_user.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the show view" do
        get :show, { id: my_user.id }
        expect(response).to render_template(:show)
      end
    end
  end

  context "premium user" do
    before do
      sign_in(my_user)
      my_user.premium!
      my_user.confirm
    end

    describe "GET show" do
      it "returns http success" do
        get :show, { id: my_user.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the show view" do
        get :show, { id: my_user.id }
        expect(response).to render_template(:show)
      end
    end

    describe "Downgrade Premium" do
      before :example do
        @user = create(:user, role: 'premium') 
        @private_wiki = create( :wiki, user: @user, private: true)
      end

      it "turns private user wikis to public" do
        request.env["HTTP_REFERER"] = user_path(@user)
        post :downgrade, { id: @user.id }
        expect(Wiki.first.private).to eq false
      end
    end
  end

end
