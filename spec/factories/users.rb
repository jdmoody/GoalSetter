# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)
#  password_digest :string(255)
#  session_token   :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

FactoryGirl.define do
  factory :user do
    username "Breakfast"
    password "meowmeow"

    factory :user_with_goal do
      username "Kiki"
      password "meowmeow"

      after(:create) do |user|
        create_list(:goal, 1, user: user)
      end
    end

    factory :user_with_private_goal do
      username "Gizmo"
      password "meowmeow"

      after(:create) do |user|
        create_list(:private_goal, 1, user: user)
      end
    end

  end
end
