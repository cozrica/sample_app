FactoryGirl.define do
  factory :relationship do
    trait :one do
      follower { FactoryGirl.create(:michael) }
      followed { FactoryGirl.create(:mina) }
    end

    trait :two do
      follower { nil }
      followed { FactoryGirl.create(:mina) }
    end
  end
end
