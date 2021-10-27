class InstanceSerializer < ActiveModel::Serializer
  attributes :id, :name, :parent_path, :log_entries, :instances_owned
end
