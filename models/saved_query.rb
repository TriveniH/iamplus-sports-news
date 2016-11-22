class SavedQuery
  include Mongoid::Document
  include Mongoid::Timestamps

  field :query,    type:String
  field :location, type:String
  field :user_uuid, type:String

  validates_uniqueness_of :query, scope:[ :location ]
end