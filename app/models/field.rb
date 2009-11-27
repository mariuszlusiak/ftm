class Field < ActiveRecord::Base

  belongs_to :user

  has_many :tournament_fields
  has_many :tournaments, :through => :tournament_fields
  has_many :game_slots

end
