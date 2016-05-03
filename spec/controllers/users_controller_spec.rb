require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:my_user) { create(:user)}

  context "guest" do

    describe "GET show" do
      it "returns http redirect" do
        get :show {id: my_user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "standard user" do
    before do
      create_session(my_user)
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
      create_session(my_user)
      my_user.premium!
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




end
