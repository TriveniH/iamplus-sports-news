class SavedSeasonEPL
  include Mongoid::Document
  include Mongoid::Timestamps

  field :event_id, 		type:String
  field :date, 	type:Time
  field :team1, type:String
  field :team2, type:String

  validates_uniqueness_of :event_id

end