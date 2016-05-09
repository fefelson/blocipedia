require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:my_user) { create(:user)}
  let(:other_user) { create(:user, name: 'eddd', role: :premium)}
  let(:my_wiki) { create(:wiki, user: my_user)}
  let(:other_wiki) { create(:wiki, user: other_user)}
  let(:private_wiki) {create(:wiki, user: other_user, private: true )}

  context "guest" do

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

        it "assigns Wiki.all to wikis" do
          get :index
          expect(assigns(:wikis)).to eq([my_wiki])
        end

        it "does not include private topics in @topics" do
          get :index
          expect(assigns(:wikis)).not_to include(private_wiki)
        end
      end

      describe "GET show" do
        it "returns http success" do
          get :show, { id: my_wiki.id }
          expect(response).to have_http_status(:success)
        end

        it "renders the #show view" do
          get :show, { id: my_wiki.id }
          expect(response).to render_template :show
        end

        it "assigns my_wiki to @wiki" do
          get :show, { id: my_wiki.id }
          expect(assigns(:wiki)).to eq(my_wiki)
        end

        it "does not show private wiki" do
          get :show, { id: private_wiki.id }
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      describe "GET new" do
        it "returns http redirect" do
          get :new
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      describe "POST create" do
        it "returns http redirect" do
          post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph }}
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      describe "GET edit" do
        it "returns http redirect" do
          get :edit, { id: my_wiki.id }
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      describe "PUT update" do
        it "returns http redirect" do
          new_title = RandomData.random_word
          new_body = RandomData.random_paragraph

          put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body, private: true }
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      describe "DELETE destroy" do
        it "returns http redirect" do
          delete :destroy, id: my_wiki
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    context "standard user" do
      before do
        my_user.confirm
        sign_in(my_user)
      end

      describe "GET index" do
        it "returns http success" do
          get :index
          expect(response).to have_http_status(:success)
        end

           it "assigns Wiki.all to wikis" do
             get :index
             expect(assigns(:wikis)).to eq([my_wiki])
           end

           it "does not include private wikis in @wikis" do
             get :index
             expect(assigns(:wikis)).not_to include(private_wiki)
           end
         end

      describe "GET show" do
        it "returns http success" do
          get :show, { id: my_wiki.id }
          expect(response).to have_http_status(:success)
        end

        it "renders the #show view" do
          get :show, { id: my_wiki.id }
          expect(response).to render_template :show
        end

        it "assigns my_wiki to @wiki" do
          get :show, { id: my_wiki.id }
          expect(assigns(:wiki)).to eq(my_wiki)
        end

        it "does not show private wiki" do
          get :show, { id: private_wiki.id }
          expect(response).to redirect_to(user_path)
        end
      end

      describe "GET new" do
        it "returns http success" do
          get :new
          expect(response).to have_http_status(:success)
        end

        it "renders the #new view" do
          get :new
          expect(response).to render_template :new
        end

        it "initialize @wiki" do
          get :new
          expect(assigns(:wiki)).not_to be_nil
        end
      end

      describe "POST create" do
        it "increases the number of wikis by 1" do
          expect{ post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph }}}.to change(Wiki, :count).by(1)
        end

        it "assigns Wiki.last to @wiki" do
          post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph }}
          expect(assigns(:wiki)).to eq Wiki.last
        end

        it "redirects to the new wiki" do
          post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph }}
          expect(response).to redirect_to Wiki.last
        end

        it "does not create private wiki" do
          expect{ post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph, private: true }}}.to change(Wiki, :count).by(0)
        end

        it " redirects private wiki to user page" do
          post :create, {wiki:  { title: RandomData.random_word, body: RandomData.random_paragraph, private: true }}
          expect(response).to redirect_to(user_path(my_user.id))
        end
      end

      describe "GET edit" do
        it "returns http success" do
          get :edit, { id: my_wiki.id }
          expect(response).to have_http_status(:success)
        end

        it "renders the #edit view" do
          get :edit, { id: my_wiki.id }
          expect(response).to render_template :edit
        end

        it "assigns wiki to be updated to @wiki" do
          get :edit, { id: my_wiki.id }
          wiki_instance = assigns(:wiki)

          expect(wiki_instance.id).to eq my_wiki.id
          expect(wiki_instance.title).to eq my_wiki.title
          expect(wiki_instance.body).to eq my_wiki.body
        end

        it "redirects to user path for private wiki" do
          get :edit, { id: private_wiki.id }
          expect(response).to redirect_to(user_path(my_user.id))
        end
      end

      describe "PUT update" do
        it "updates topic with expected attributes" do
          new_title = RandomData.random_word
          new_body = RandomData.random_paragraph

          put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body }
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.id).to eq my_wiki.id
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
        end

        it "redirects to the updated wiki" do
          new_title = RandomData.random_word
          new_body = RandomData.random_paragraph

          put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body }
          expect(response).to redirect_to my_wiki
        end

        it "does not update public wiki to private" do
          put :update, id: my_wiki.id, wiki: { private: true }
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.private).to eq(false)
        end

        it "redirects to user path for making public wiki private" do
          put :update, id: my_wiki.id, wiki: { private: true }
          expect(response).to redirect_to(user_path(my_user.id))
        end
      end

      describe "DELETE destroy" do
        it "deletes the wiki" do
          delete :destroy, {id: my_wiki.id}
          count = Wiki.count
          expect(count).to eq 1
        end

        it "redirects to wiki index" do
          delete :destroy, {id: my_wiki.id}
          expect(response).to redirect_to user_path(my_user.id)
        end

        it "redirects to user path for private wiki" do
          delete :destroy, {id: private_wiki.id }
          expect(response).to redirect_to user_path(my_user.id)
        end
      end

      describe "A wiki the user doesnt own" do
        it "GET edit returns http success" do
          get :edit, { id: other_wiki.id }
          expect(response).to have_http_status(:success)
        end

        it "GET edit renders the #edit view" do
          get :edit, { id: other_wiki.id }
          expect(response).to render_template :edit
        end

        it "GET edit assigns wiki to be updated to @wiki" do
          get :edit, { id: other_wiki.id }
          wiki_instance = assigns(:wiki)

          expect(wiki_instance.id).to eq other_wiki.id
          expect(wiki_instance.title).to eq other_wiki.title
          expect(wiki_instance.body).to eq other_wiki.body
        end

        it "PUT update updates topic with expected attributes" do
          new_title = RandomData.random_word
          new_body = RandomData.random_paragraph

          put :update, id: other_wiki.id, wiki: { title: new_title, body: new_body }
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.id).to eq other_wiki.id
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
        end

        it "PUT update redirects to the updated wiki" do
          new_title = RandomData.random_word
          new_body = RandomData.random_paragraph

          put :update, id: other_wiki.id, wiki: { title: new_title, body: new_body }
          expect(response).to redirect_to other_wiki
        end
      end
    end

    context "premium user" do
      before do
        my_user.premium!
        my_user.confirm
        sign_in(my_user)
      end

      describe "GET index" do
        it "returns http success" do
          get :index
          expect(response).to have_http_status(:success)
        end

        it "assigns Wiki.all to wikis" do
          get :index
          expect(assigns(:wikis)).to eq([my_wiki, private_wiki])
        end
      end

      describe "GET show" do
        it "returns http success" do
          get :show, { id: my_wiki.id }
          expect(response).to have_http_status(:success)
        end

        it "renders the #show view" do
          get :show, { id: my_wiki.id }
          expect(response).to render_template :show
        end

        it "assigns my_wiki to @wiki" do
          get :show, { id: my_wiki.id }
          expect(assigns(:wiki)).to eq(my_wiki)
        end

        describe "private wiki" do
          it "returns http success" do
            get :show, { id: private_wiki.id }
            expect(response).to have_http_status(:success)
          end

          it "renders the #show view" do
            get :show, { id: private_wiki.id }
            expect(response).to render_template :show
          end

          it "assigns private wiki to @wiki" do
            get :show, { id: private_wiki.id }
            expect(assigns(:wiki)).to eq(private_wiki)
          end
        end
      end

      describe "GET new" do
        it "returns http success" do
          get :new
          expect(response).to have_http_status(:success)
        end

        it "renders the #new view" do
          get :new
          expect(response).to render_template :new
        end

        it "initialize @wiki" do
          get :new
          expect(assigns(:wiki)).not_to be_nil
        end

      end

      describe "POST create" do
        it "increases the number of wikis by 1" do
          expect{ post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph }}}.to change(Wiki, :count).by(1)
        end

        it "assigns Wiki.last to @wiki" do
          post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph }}
          expect(assigns(:wiki)).to eq Wiki.last
        end

        it "redirects to the new wiki" do
          post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph }}
          expect(response).to redirect_to Wiki.last
        end

        describe "private wiki" do
          it "increases the number of wikis by 1" do
            expect{ post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph, private: true }}}.to change(Wiki, :count).by(1)
          end

          it "assigns Wiki.last to @wiki" do
            post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph, private: true }}
            expect(assigns(:wiki)).to eq Wiki.last
          end

          it "redirects to the new wiki" do
            post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph, private: true }}
            expect(response).to redirect_to Wiki.last
          end
        end
      end

      describe "GET edit" do
        it "returns http success" do
          get :edit, { id: my_wiki.id }
          expect(response).to have_http_status(:success)
        end

        it "renders the #edit view" do
          get :edit, { id: my_wiki.id }
          expect(response).to render_template :edit
        end

        it "assigns wiki to be updated to @wiki" do
          get :edit, { id: my_wiki.id }
          wiki_instance = assigns(:wiki)

          expect(wiki_instance.id).to eq my_wiki.id
          expect(wiki_instance.title).to eq my_wiki.title
          expect(wiki_instance.body).to eq my_wiki.body
        end

        describe "private wiki" do
          it "returns http success" do
            get :edit, { id: private_wiki.id }
            expect(response).to have_http_status(:success)
          end

          it "renders the #edit view" do
            get :edit, { id: private_wiki.id }
            expect(response).to render_template :edit
          end

          it "assigns wiki to be updated to @wiki" do
            get :edit, { id: private_wiki.id }
            wiki_instance = assigns(:wiki)

            expect(wiki_instance.id).to eq private_wiki.id
            expect(wiki_instance.title).to eq private_wiki.title
            expect(wiki_instance.body).to eq private_wiki.body
          end
        end
      end

      describe "PUT update" do
        it "updates topic with expected attributes" do
          new_title = RandomData.random_word
          new_body = RandomData.random_paragraph

          put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body, private: true }
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.id).to eq my_wiki.id
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
          expect(updated_wiki.private).to eq(true)
        end

        it "redirects to the updated wiki" do
          new_title = RandomData.random_word
          new_body = RandomData.random_paragraph

          put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body }
          expect(response).to redirect_to my_wiki
        end

        describe "private wiki" do
          it "updates public wiki to private with expected attributes" do
            new_title = RandomData.random_word
            new_body = RandomData.random_paragraph

            put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body, private: true }
            updated_wiki = assigns(:wiki)
            expect(updated_wiki.id).to eq my_wiki.id
            expect(updated_wiki.title).to eq new_title
            expect(updated_wiki.body).to eq new_body
          end

          it "redirects to the updated wiki" do
            new_title = RandomData.random_word
            new_body = RandomData.random_paragraph

            put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body, private: true }
            expect(response).to redirect_to my_wiki
          end
        end
      end

      describe "DELETE destroy" do
        it "does not delete the wiki" do
          delete :destroy, {id: my_wiki.id}
          count = Wiki.count
          expect(count).to eq 1
        end

        it "redirects to wiki" do
          delete :destroy, {id: my_wiki.id}
          expect(response).to redirect_to user_path(my_user.id)
        end
      end
    end

    context "admin" do
      before do
        my_user.confirm
        my_user.admin!
        sign_in(my_user)
      end

      describe "GET index" do
        it "returns http success" do
          get :index
          expect(response).to have_http_status(:success)
        end

        it "assigns Wiki.all to wikis" do
          get :index
          expect(assigns(:wikis)).to eq([my_wiki, private_wiki])
        end
      end

      describe "GET show" do
        it "returns http success" do
          get :show, { id: my_wiki.id }
          expect(response).to have_http_status(:success)
        end

        it "renders the #show view" do
          get :show, { id: my_wiki.id }
          expect(response).to render_template :show
        end

        it "assigns my_wiki to @wiki" do
          get :show, { id: my_wiki.id }
          expect(assigns(:wiki)).to eq(my_wiki)
        end

        describe "private wiki" do
          it "returns http success" do
            get :show, { id: private_wiki.id }
            expect(response).to have_http_status(:success)
          end

          it "renders the #show view" do
            get :show, { id: private_wiki.id }
            expect(response).to render_template :show
          end

          it "assigns private wiki to @wiki" do
            get :show, { id: private_wiki.id }
            expect(assigns(:wiki)).to eq(private_wiki)
          end
        end
      end

      describe "GET new" do
        it "returns http success" do
          get :new
          expect(response).to have_http_status(:success)
        end

        it "renders the #new view" do
          get :new
          expect(response).to render_template :new
        end

        it "initialize @wiki" do
          get :new
          expect(assigns(:wiki)).not_to be_nil
        end

      end

      describe "POST create" do
        it "increases the number of wikis by 1" do
          expect{ post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph }}}.to change(Wiki, :count).by(1)
        end

        it "assigns Wiki.last to @wiki" do
          post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph }}
          expect(assigns(:wiki)).to eq Wiki.last
        end

        it "redirects to the new wiki" do
          post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph }}
          expect(response).to redirect_to Wiki.last
        end

        describe "private wiki" do
          it "increases the number of wikis by 1" do
            expect{ post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph, private: true }}}.to change(Wiki, :count).by(1)
          end

          it "assigns Wiki.last to @wiki" do
            post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph, private: true }}
            expect(assigns(:wiki)).to eq Wiki.last
          end

          it "redirects to the new wiki" do
            post :create, {wiki: { title: RandomData.random_word, body: RandomData.random_paragraph, private: true }}
            expect(response).to redirect_to Wiki.last
          end
        end
      end

      describe "GET edit" do
        it "returns http success" do
          get :edit, { id: my_wiki.id }
          expect(response).to have_http_status(:success)
        end

        it "renders the #edit view" do
          get :edit, { id: my_wiki.id }
          expect(response).to render_template :edit
        end

        it "assigns wiki to be updated to @wiki" do
          get :edit, { id: my_wiki.id }
          wiki_instance = assigns(:wiki)

          expect(wiki_instance.id).to eq my_wiki.id
          expect(wiki_instance.title).to eq my_wiki.title
          expect(wiki_instance.body).to eq my_wiki.body
        end

        describe "private wiki" do
          it "returns http success" do
            get :edit, { id: private_wiki.id }
            expect(response).to have_http_status(:success)
          end

          it "renders the #edit view" do
            get :edit, { id: private_wiki.id }
            expect(response).to render_template :edit
          end

          it "assigns wiki to be updated to @wiki" do
            get :edit, { id: private_wiki.id }
            wiki_instance = assigns(:wiki)

            expect(wiki_instance.id).to eq private_wiki.id
            expect(wiki_instance.title).to eq private_wiki.title
            expect(wiki_instance.body).to eq private_wiki.body
          end
        end
      end

      describe "PUT update" do
        it "updates topic with expected attributes" do
          new_title = RandomData.random_word
          new_body = RandomData.random_paragraph

          put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body, private: true }
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.id).to eq my_wiki.id
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
          expect(updated_wiki.private).to eq(true)
        end

        it "redirects to the updated wiki" do
          new_title = RandomData.random_word
          new_body = RandomData.random_paragraph

          put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body }
          expect(response).to redirect_to my_wiki
        end

        describe "private wiki" do
          it "updates public wiki to private with expected attributes" do
            new_title = RandomData.random_word
            new_body = RandomData.random_paragraph

            put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body, private: true }
            updated_wiki = assigns(:wiki)
            expect(updated_wiki.id).to eq my_wiki.id
            expect(updated_wiki.title).to eq new_title
            expect(updated_wiki.body).to eq new_body
          end

          it "redirects to the updated wiki" do
            new_title = RandomData.random_word
            new_body = RandomData.random_paragraph

            put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body, private: true }
            expect(response).to redirect_to my_wiki
          end
        end
      end

      describe "DELETE destroy" do
        it "deletes the wiki" do
          delete :destroy, {id: my_wiki.id}
          count = Wiki.count
          expect(count).to eq 0
        end

        it "redirects to wiki wiki index" do
          delete :destroy, {id: my_wiki.id}
          expect(response).to redirect_to wikis_path
        end

        describe "private wiki" do
          it "deletes the wiki" do
            delete :destroy, {id: private_wiki.id}
            count = Wiki.count
            expect(count).to eq 0
          end

          it "redirects to wiki index" do
            delete :destroy, {id: private_wiki.id}
            expect(response).to redirect_to wikis_path
          end
        end
      end
    end

end
