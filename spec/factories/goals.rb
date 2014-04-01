# == Schema Information
#
# Table name: goals
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :string(255)
#  body       :text
#  is_private :boolean
#  completed  :boolean
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :goal do
    title Faker::Lorem.words(5).join(" ")
    body Faker::Lorem.sentence
    user

    factory :private_goal do
      title Faker::Lorem.words(5).join(" ")
      body Faker::Lorem.sentence
      is_private true
      user
    end
  end
end
