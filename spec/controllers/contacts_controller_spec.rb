require 'rails_helper'

describe ContactsController do
  shared_examples_for 'public access to contacts' do
    let(:contact){create(:contact, firstname: 'Lawrence', lastname: 'Smith')}
    let(:smith){create(:contact, lastname: 'Smith')}
    let(:jones){create(:contact, lastname: 'Jones')}
    describe 'GET #index' do
      context 'with params[:letter]' do
        it "populates an array of contacts starting with the letter" do
          get :index, letter: 'S'
          expect(assigns(:contacts)).to match_array([smith])
        end

        it "renders the :index template" do
          get :index, letter: 'S'
          expect(response).to render_template :index
        end
      end

      context 'without params[:letter]' do
        it "populates an array of all contacts" do
          get :index
          expect(assigns(:contacts)).to match_array([smith, jones])
        end

        it "renders the :index template" do
          get :index
          expect(response).to render_template :index
        end
      end
    end

    describe 'GET #show' do
      it "assigns the requested contact to @contact" do
        get :show, id: contact
        expect(assigns(:contact)).to eq contact
      end

      it "renders the :show template" do
        get :show, id: contact
        expect(response).to render_template :show
      end
    end
  end

  shared_examples 'full access to contacts' do
    describe 'GET #new' do
      let(:phones) do
        phones = assigns(:contact).phones.map do |p|
          p.phone_type
        end
      end

      it "assigns a new Contact to @contact" do
        get :new
        expect(assigns(:contact)).to be_a_new(Contact)
      end

      it "assigns a home, office, and mobile phone to the new contact" do
        get :new
        expect(phones).to match_array %w(home office mobile)
      end

      it "renders the :new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      let(:contact){contact = create(:contact)}
      it "assigns the requested contact to @contact" do
        contact
        get :edit, id: contact
        expect(assigns(:contact)).to eq contact
      end

      it "renders the :edit template" do
        get :edit, id: contact
        expect(response).to render_template :edit
      end
    end

    describe "POST #create" do
      before :each do
        @phones_attr = [
          attributes_for(:phone),
          attributes_for(:phone),
          attributes_for(:phone)
        ]
      end

      context "with valid attributes" do
        it "saves the new contact in the database" do
          expect{
            post :create, contact: attributes_for(:contact,
              phones_attributes: @phones_attr)
          }.to change(Contact, :count).by(1)
        end

        it "redirects to contacts#show" do
          post :create,
            contact: attributes_for(:contact,
              phones_attributes: @phones_attr)
          expect(response).to redirect_to contact_path(assigns[:contact])
        end
      end

      context "with invalid attributes" do
        it "does not save the new contact in the database" do
          expect{
            post :create,
              contact: attributes_for(:invalid_contact)
          }.not_to change(Contact, :count)
        end

        it "re-renders the :new template" do
          post :create,
            contact: attributes_for(:invalid_contact)
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      let(:contact) do
        create(:contact,
               firstname: 'Lawrence',
               lastname: 'Smith'
        )
      end

      context "valid attributes" do
        it "locates the requested @contact" do
          patch :update, id: contact,
            contact: attributes_for(:contact)
          expect(assigns(:contact)).to eq contact
        end

        it "changes the contact's attributes" do
          patch :update, id: contact,
            contact: attributes_for(:contact,
              firstname: 'Larry',
              lastname: 'Smith'
            )
          contact.reload
          expect(contact.firstname).to eq 'Larry'
          expect(contact.lastname).to eq 'Smith'
        end

        it "redirects to the updated contact" do
          patch :update, id: contact, contact: attributes_for(:contact)
          expect(response).to redirect_to contact
        end
      end

      context "invalid attributes" do
        it "locates the requested @contact" do
          patch :update, id: contact, contact: attributes_for(:invalid_contact)
          expect(assigns(:contact)).to eq contact
        end

        it "does not change the contact's attributes" do
          patch :update, id: contact,
            contact: attributes_for(:contact,
              firstname: 'Larry',
              lastname: nil
            )
          contact.reload
          expect(contact.firstname).not_to eq('Larry')
          expect(contact.lastname).to eq('Smith')
        end

        it "re-renders the edit method" do
          patch :update, id: contact, contact: attributes_for(:invalid_contact)
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:contact) {@contact = create(:contact)}
      it "deletes the contact" do
        expect{
          delete :destroy, id: contact
        }.to change(Contact,:count).by(-1)
      end

      it "redirects to contacts#index" do
        delete :destroy, id: contact
        expect(response).to redirect_to contacts_url
      end
    end
  end

  describe "administrator access" do
    before :each do
      set_user_session create(:admin)
    end

    it_behaves_like 'public access to contacts'
    it_behaves_like 'full access to contacts'
  end

  describe "user access" do
    before :each do
      set_user_session create(:user)
    end

    it_behaves_like 'public access to contacts'
    it_behaves_like 'full access to contacts'
  end

  describe "guest access" do
    it_behaves_like 'public access to contacts'
    let(:contact){create(:contact)}
    let(:contact_attr){attributes_for(:contact)}

    subject{response}
    describe 'GET #new' do
      it "requires login" do
        get :new
        is_expected.to require_login
      end
    end

    describe 'GET #edit' do
      it "requires login" do
        get :edit, id: contact
        is_expected.to require_login
      end
    end

    describe "POST #create" do
      it "requires login" do
        post :create, id: contact, contact: contact_attr
        is_expected.to require_login
      end
    end

    describe 'PUT #update' do
      it "requires login" do
        put :update, id: contact,
          contact: contact_attr
        is_expected.to require_login
      end
    end

    describe 'DELETE #destroy' do
      it "requires login" do
        delete :destroy, id: contact
        is_expected.to require_login
      end
    end
  end
end
