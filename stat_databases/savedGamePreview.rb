class SavedGamePreview
  include Mongoid::Document
  include Mongoid::Timestamps

  field :event_id, 		type:String
  field :date, 	type:Time
  field :date_type, type:String
  field :image_url, type:String
  field :headline, type:String
  field :paragraphs, type:Array
  field :league_name, type:String
  field :error_code, type:String
  field :error_message, type:String

  validates_uniqueness_of :event_id
end