class SerializableRequest < JSONAPI::Serializable::Resource
  type 'requests'

  attributes :bill_of_lading, :scac

end
