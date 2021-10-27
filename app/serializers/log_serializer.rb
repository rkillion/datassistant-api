class LogSerializer < ActiveModel::Serializer
  attributes :id, :note, :action, :relationship, :type_a_id, :type_b_id, :reference, :created_at, :instance_a_id, :instance_b_id, :base_type_a_id, :base_type_b_id
  has_one :datassistant
end
