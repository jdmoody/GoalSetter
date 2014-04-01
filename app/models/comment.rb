# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :text
#  author_id        :integer
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  validates :body, :author_id, :commentable_id, presence: true

  belongs_to :author, class_name: "User"
  belongs_to :commentable, polymorphic: true
end
