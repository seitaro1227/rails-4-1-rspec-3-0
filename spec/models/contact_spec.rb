require 'rails_helper'

describe Contact do # ,type: :model do
let(:contact){build(:contact)}

  it "has a valid factory" do
    expect(contact).to be_valid
  end

  context "is invalid" do
    specify{ should validate_presence_of(:firstname)}
    specify{ should validate_presence_of(:lastname)}
    specify{ should validate_presence_of(:email)}
    specify{ should validate_uniqueness_of(:email)}
  end

  it "returns a contact's full name as a string" do
     contact.firstname= 'Jane'
     contact.lastname= 'Smith'
    expect(contact.name).to eq 'Jane Smith'
  end

  it "has three phone numbers" do
    expect(create(:contact).phones.count).to eq 3
  end

  describe "filter last name by letter" do
    before :each do
      @smith = create(:contact,
        firstname: 'John',
        lastname: 'Smith',
        email: 'jsmith@example.com'
      )
      @jones = create(:contact,
        firstname: 'Tim',
        lastname: 'Jones',
        email: 'tjones@example.com'
      )
      @johnson = create(:contact,
        firstname: 'John',
        lastname: 'Johnson',
        email: 'jjohnson@example.com'
      )
    end
    subject{Contact.by_letter("J")}
    context "with matching letters" do
      it "returns a sorted array of results that match" do
        is_expected.to eq [@johnson, @jones]
      end
    end

    context "with non-matching letters" do
      it "omits results that do not match" do
        is_expected.not_to include @smith
      end
    end
  end
end
