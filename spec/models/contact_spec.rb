require 'rails_helper'

describe Contact do
  before :each do
    @contact = Contact.new(
        firstname: 'Aaron',
        lastname: 'Sumner',
        email: 'tester@example.com'
    )
  end
  it 'is Valid with a firstname, lastname and email' do
    expect(@contact).to be_valid
  end

  it 'is invalid without a firstname'do
    @contact.firstname =''
    expect(@contact).to_not be_valid
    expect(@contact.errors[:firstname]).to include("can't be blank")
  end

  it 'is invalid without a lastname'do
    @contact.lastname= ''
    expect(@contact).to_not be_valid
    expect(@contact.errors[:lastname]).to include("can't be blank")
  end

  it 'is invalid without a email address' do
    @contact.email= ''
    expect(@contact).to_not be_valid
    expect(@contact.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a duplicate email address' do
    email = 'tester@example.com'
    Contact.create(
        firstname: 'Joe',
        lastname: 'Tester',
        email: email
    )
    @contact.email= email
    @contact.valid?
    expect(@contact.errors[:email]).to include('has already been taken')
  end


  it "returns a contact's full name as a string" do
    firstname = 'John'
    lastname = 'Doe'
    @contact.firstname= firstname
    @contact.lastname= lastname
    expect(@contact.name).to eq "#{firstname} #{lastname}"
  end

  describe "filter last name by letter" do
    before :each do
      @smith = Contact.create(
          firstname: 'John',
          lastname: 'Smith',
          email: 'jsmith@example.com'
      )

      @jones = Contact.create(
          firstname: 'Tim',
          lastname: 'Jones',
          email: 'tjones@example.com'
      )

      @johnson = Contact.create(
          firstname: 'John',
          lastname: 'Johnson',
          email: 'jjohnson@example.com'
      )
    end

    context "with matching letters" do
      it 'returns sorted array of results that match' do
        expect(Contact.by_letter('J')).to eq [@johnson,@jones]
      end
    end

    context "with non-matching letters" do
      it 'omits results that do not match' do
        expect(Contact.by_letter('J')).not_to include @smith
      end
    end
  end
end