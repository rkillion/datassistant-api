class Datassistant < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, uniqueness: {scope: :user, message: "already exists"}
end
