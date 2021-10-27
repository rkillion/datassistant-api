class TypeSerializer < ActiveModel::Serializer
  attributes :id, :title_singular, :title_plural, :sub_types, :parent_path, :instances, :log_entries, :granted_types
end
