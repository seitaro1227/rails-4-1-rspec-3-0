FactoryGirl.define do
  factory :contact do
    firstname {Faker::Name.first_name}
    lastname {Faker::Name.last_name}
    email {Faker::Internet.email}

    after(:build) do |contact|
      %w"home_phone work_phone mobile_phone".each do |phone|
        create_phone = FactoryGirl.create(phone, phone_type: phone, contact: contact)
        contact.phones << create_phone
      end
    end
  end
end