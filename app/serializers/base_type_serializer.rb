class BaseTypeSerializer < ActiveModel::Serializer
  attributes :id, :title_singular, :title_plural, :value_type
end
