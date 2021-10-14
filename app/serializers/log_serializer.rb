class LogSerializer < ActiveModel::Serializer
  attributes :id, :note, :action, :relationship, :type_a_id, :type_b_id
  has_one :datassistant
end
