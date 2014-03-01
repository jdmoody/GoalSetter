module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable
  end

  # def tag_names
 #    tags.map(&:name)
 #  end
end