class SavedHeadLines
  include Mongoid::Document
  include Mongoid::Timestamps

  field :publish_date, 	type:Time
  field :date_type, type:String
  field :image_url, type:String
  field :headlines, type:Array
  field :league_name, type:String
  field :team_id, type:String

  index({ created_at: 1 }, {expire_after_seconds: 86400})
end