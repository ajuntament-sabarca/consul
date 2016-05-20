class Budget
  class Ballot < ActiveRecord::Base
    belongs_to :user
    belongs_to :budget
    belongs_to :geozone

    has_many :lines, dependent: :destroy
    has_many :spending_proposals, through: :lines
  end
end