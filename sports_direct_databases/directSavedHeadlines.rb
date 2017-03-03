class DirectSavedHeadLines
  include Mongoid::Document
  include Mongoid::Timestamps

  field :article_id,    type:String
  field :publication_date, type:String
  field :author,  type:String
  field :source, type:String
  field :title, type:String
  field :synopsis, type:String
  field :body, type:String
  field :league_name, type:String
  field :team_id, type:String
  field :team_name, type:String

  index({ created_at: 1 }, {expire_after_seconds: 86400})
end