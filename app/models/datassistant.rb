class Datassistant < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, uniqueness: {scope: :user, message: "already exists"}
  has_many :types, dependent: :destroy
  has_many :logs, dependent: :destroy
  has_many :base_types, foreign_key: :datassistant_id, dependent: :destroy
  has_many :instances, dependent: :destroy

  def sub_types
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
