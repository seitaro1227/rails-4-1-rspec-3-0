require 'rails_helper'

describe UsersController do
  describe 'user access' do
    before{session[:user_id] = user.id}
    subject{response}
    let(:user){create(:user)}

    describe 'GET #index' do
      it "collects users into @users" do
        other_user = create(:user)
        get :index
        expect(assigns(:users)).to match_array [user,other_user]
      end

      it "renders the :index template" do
        get :index
        is_expected.to render_template :index
      end
    end

    it "GET #new denies access" do
      get :new
      is_expected.to redirect_to root_url
    end

    it "POST#create denies access" do
      post :create, user: attributes_for(:user)
      is_expected.to redirect_to root_url
    end
  end
end