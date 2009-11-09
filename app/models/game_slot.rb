class GameSlot < ActiveRecord::Base

  belongs_to :tournament
  has_one :game

end
