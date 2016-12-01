class SavedGameRecap
  include Mongoid::Document
  include Mongoid::Timestamps

  field :event_id, 		type:String
  field :date, 	type:Time
  field :date_type, type:String
  field :image_url, type:String
  field :headline, type:String
  field :paragraphs, type:Array
  field :league_name, type:String

  validates_uniqueness_of :event_id

  index({ created_at: 1 }, {expire_after_seconds: 86400})
end