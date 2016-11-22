class APIRequestCounter
  include Mongoid::Document
  include Mongoid::Timestamps

  field :domain, type:String
  field :path,   type:String
end