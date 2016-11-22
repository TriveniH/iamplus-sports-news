class SavedGame
  include Mongoid::Document
  include Mongoid::Timestamps

  field :event_id, 		type:String
  field :time_taken, 		type:String
  field :date, 	type:Time
  field :date_type, type:String
  field :image_url, type:String
  field :headline, type:String
  field :paragraphs, type:Array

  validates_uniqueness_of :event_id
end