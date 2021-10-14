class BaseType < ApplicationRecord
    validates :title_singular, :title_plural, uniqueness: true, presence: true
    validates :value_type, presence: true
end
