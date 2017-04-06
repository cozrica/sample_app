FactoryGirl.define do
  factory :user do
    name 'lana'
    email 'lana@example.com'
    password_digest User.digest('password')
    admin false
    activated true
    activated_at Time.zone.now
  end

  factory :michael, class: User do
    name 'Michael Example'
    email 'michael@example.com'
    password_digest User.digest('password')
    admin true
    activated true
    activated_at Time.zone.now
  end

  factory :mina, class: User do
    name 'Mina nami'
    email 'mina@example.com'
    password_digest User.digest('password')
    admin true
    activated true
    activated_at Time.zone.now
  end
end
