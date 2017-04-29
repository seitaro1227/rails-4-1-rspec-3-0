require 'rails_helper'

describe UsersController do
  describe 'user access' do
    before :each do
      @user = create(:user)
      session[:user_id] = @user.id
    end

    describe 'GET #index' do
      it "collect users into @users" do
        user = create(:user)
        get :index

        expect(assigns(:users)).to match_array [@user, user]
      end

      it "render the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end

    it "GET #new" do
      get :new
      expect(response).to redirect_to root_url
    end

    it "POST #create" do
      attr = attributes_for(:user)
      post :create,user: attr
      expect(response).to redirect_to root_url
    end
  end
end