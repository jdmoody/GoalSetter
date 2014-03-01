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

class Goal < ActiveRecord::Base
  validates :title, :user_id, presence: true

  belongs_to :user
  after_initialize :init

  private
  def init
    self.is_private ||= false
    self.completed ||= false
  end
end
