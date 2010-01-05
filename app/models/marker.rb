# encoding: utf-8

class Marker < CouchRestRails::Document
  use_database :rowery
  
  unique_id :name

  property :name
  property :description
  property :category #, :cast_as => Integer
  property :lat, :cast_as => Float
  property :lng, :cast_as => Float
  property :user
  property :user_ip
  property :_attachments
  timestamps!

  validates_present :name, :description, :lat, :lng, :category

  validates_with_method :name, :method => :name_is_unique

#  view_by :all

  def name_is_unique
    m = Marker.get(name)
    m === nil or (m.rev == rev) ? true : [false, "Punkt o tej nazwie już istnieje"]
  end
end