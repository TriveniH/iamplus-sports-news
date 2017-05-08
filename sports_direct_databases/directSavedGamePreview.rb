class DirectSavedGamePreview
  include Mongoid::Document
  include Mongoid::Timestamps

  field :competition_id, 		type:String
  field :article_id,    type:String
  field :competition_date, 	type:Time
  field :author,  type:String
  field :source, type:String
  field :publication_date, type:String
  field :title, type:String
  field :synopsis, type:String
  field :body, type:String
  field :league_name, type:String
  field :error_code, type:String
  field :error_message, type:String

  validates_uniqueness_of :competition_id
end