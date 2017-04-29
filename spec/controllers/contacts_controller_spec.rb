require 'rails_helper'

describe ContactsController do
  describe 'GET #index' do
    before :each do
      @smith = create(:contact,lastname:'Smith')
      @jones = create(:contact,lastname:'Jones')
    end

    context 'with params[:letter]' do
      it "populates an array of contacts starting with the letter"do
        get :index, letter: 'S'
        expect(assigns(:contacts)).to match_array([@smith])
      end
      it "renders the :index template" do
        get :index, letter: 'S'
        expect(response).to render_template :index
      end
    end

    context 'without params[:letter]' do
      it "populates an array of all contacts"do
        get :index
        expect(assigns(:contacts)).to match_array([@smith,@jones])
      end
      it "renders the :index template" do
      get :index
      expect(response).to render_template :index
      end
    end
  end

  describe 'GET #show' do
    before :each do
      @contact = create(:contact)
    end
    it 'assigns the requested contact to @contact'do
      get :show, id: @contact
      expect(assigns(:contact)).to eq @contact
    end
    it 'renders the :show template'do
      get :show, id: @contact
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'assigns a new Contact to @contact'do
      get :new
      expect(assigns(:contact)).to be_a_new(Contact)
    end
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before :each do
      @contact = create(:contact)
    end
    it 'assigns the requested contact to @contact' do
      get :edit, id: @contact
      expect(assigns(:contact)).to eq @contact
    end
    it 'renders the :edit template' do
      get :edit, id: @contact
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before :each do
      @phones= [
          attributes_for(:phone),
          attributes_for(:phone),
          attributes_for(:phone)
      ]
      @contact_attr = attributes_for(:contact, phones_attributes: @phones)
      @invalid_contact_attr = attributes_for(:invalid_contact)
    end

    context 'with valid attributes' do
      it "saves the new contact in the database" do
        expect{post :create, contact: @contact_attr}.to(
          change(Contact, :count).by(1)
        )
      end

      it "redirects to contacts#show" do
        post :create, contact: @contact_attr
        expect(response).to(redirect_to contact_path(assigns[:contact]))
      end
    end

    context 'with invalid attributes' do
      it "does not save the new contact in the database" do
        expect{post :create, contact: @invalid_contact_attr}.not_to(
            change(Contact,:count)
        )
      end
      it "re-renders the :new template" do
        post :create, contact: @invalid_contact_attr
        expect(response).to(render_template :new)
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @contact = create(:contact,
                        firstname: 'Lawrence',
                        lastname: 'Smith')
    end

    context 'with valid attributes' do
      it "locates the requested @contact" do
        attr = attributes_for(:contact,
                              firstname: 'Lawrence',
                              lastname: 'Smith')
        patch :update, id: @contact, contact: attr

        expect(assigns(:contact)).to eq(@contact)
      end

      it "updates the contact in the database" do
        attr = attributes_for(:contact,
                              firstname: 'Larry',
                              lastname: 'Smith')

        patch :update, id: @contact, contact: attr
        @contact.reload

        expect(@contact.firstname).to eq('Larry')
        expect(@contact.lastname).to eq('Smith')
      end
      it "redirects to the contact" do
        attr = attributes_for(:contact)
        patch :update, id: @contact, contact: attr

        expect(response).to redirect_to(@contact)
      end
    end

    context 'with invalid attributes' do
      it "does not update the contact's attributes" do
        attr = attributes_for(:contact,
                              firstname: 'Larry',
                              lastname: nil)
        patch :update, id: @contact, contact: attr
        @contact.reload

        expect(@contact.firstname).not_to eq('Larry')
        expect(@contact.lastname).to eq('Smith')
      end

      it "re-renders the :edit template" do
        attr = attributes_for(:invalid_contact)
        patch :update, id: @contact, contact: attr

        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @contact = create(:contact)
    end

    it "deletes the contact from the database" do
      expect {
        delete :destroy, id: @contact
      }.to change(Contact, :count).by(-1)
    end

    it "redirects to contacts#index" do
      delete :destroy, id: @contact
      expect(response).to redirect_to contacts_url
    end
  end
end