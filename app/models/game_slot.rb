class GameSlot < ActiveRecord::Base

  belongs_to :tournament
  belongs_to :field
  has_one :game

end
