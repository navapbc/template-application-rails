FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    uid { Faker::Internet.uuid }
    provider { "factory_bot" }
    mfa_preference { "opt_out" }

    trait :claimant do
      user_role { create(:user_role, :claimant) }
    end

    trait :employer do
      user_role { create(:user_role, :employer) }
    end

    trait :superadmin do
      email { "test+admin@navapbc.com" }
    end
  end
end
