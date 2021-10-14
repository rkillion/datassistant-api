class Type < ApplicationRecord
  belongs_to :datassistant
  has_many :logs, foreign_key: :type_a_id, dependent: :destroy
  has_many :reverse_logs, class_name: "Log", foreign_key: :type_b_id, dependent: :destroy

  def relationships
    logs = Log.where(type_a_id: self.id).where.not(relationship: nil)
    logs.map{ |log| log.relationship }
  end

  def sub_types
    logs = Log.where(type_a_id: self.id).where(relationship: "child")
    logs.map{|log| Type.find(log.type_b_id)}
  end

  def make_subtype(singular,plural)
    newType = Type.create(
      datassistant_id: self.datassistant.id,
      title_singular: singular,
      title_plural: plural
    )
    self.make_relationship(newType,"child")
    newType
  end

  def make_relationship(type,relationship)
    Log.create(
      relationship: relationship,
      type_a_id: self.id,
      type_b_id: type.id,
      datassistant_id: self.datassistant.id
    )
    Log.create(
      relationship: corresponding_relative[relationship.to_sym],
      type_b_id: self.id,
      type_a_id: type.id,
      datassistant_id: self.datassistant.id
    )
  end

  private

  def corresponding_relative
    {
      parent: "child",
      child: "parent"
    }
  end
end
