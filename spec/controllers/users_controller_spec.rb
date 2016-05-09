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
      let(:private_wiki) {create(:wiki, user: my_user, private: true)}

      it "turns private user wikis to public" do
        request.env["HTTP_REFERER"] = user_path(my_user)
        post :downgrade, {user_id: my_user.id}
        expect(private_wiki.private?).to eq false
      end
    end
  end

end
