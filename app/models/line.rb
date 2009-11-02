class Line < CouchRestRails::Document
  use_database :rowery

#  unique_id :name

  property :name
  property :description

end
