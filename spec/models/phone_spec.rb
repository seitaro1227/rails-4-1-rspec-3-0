require 'rails_helper'

describe Phone do
  it 'does not allow duplicate phone number pre contact' do
    contact = Contact.create(
        firstname: 'Joe',
        lastname: 'Tester',
        email: 'joetester@exmaple.com'
    )
    contact.phones.create(
        phone_type:'home',
        phone: '785-555-1234'
    )

    mobile_phone = contact.phones.build(
        phone_type: 'mobile',
        phone: '785-555-1234'
    )

    mobile_phone.valid?
    expect(mobile_phone.errors[:phone]).to include('has already been taken')
  end

  it 'allows two contacts share a phone number' do
    contact = Contact.create(
        firstname: 'Joe',
        lastname: 'Tester',
        email: 'joetester@exmaple.com'
    )
    contact.phones.create(
        phone_type:'home',
        phone: '785-555-1234'
    )

    other_contact = Contact.new
    other_phone = other_contact.phones.build(
        phone_type: 'home',
        phone: '785-555-1234'
    )

    expect(other_phone).to be_valid
  end
end