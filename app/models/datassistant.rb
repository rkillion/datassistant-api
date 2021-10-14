class Datassistant < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, uniqueness: {scope: :user, message: "already exists"}
  has_many :types, dependent: :destroy
  has_many :logs, dependent: :destroy

  def custom_base_types
    self.types.filter{|type| type.relationships.include?("base")}
  end

  def new_type(singular,plural)
    Type.create(
      datassistant_id: self.id,
      title_singular: singular,
      title_plural: plural
    )
  end

end
