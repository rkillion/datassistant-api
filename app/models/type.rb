class Type < ApplicationRecord
  belongs_to :datassistant
  has_many :logs, foreign_key: :type_a_id, dependent: :destroy
  has_many :reverse_logs, class_name: "Log", foreign_key: :type_b_id, dependent: :destroy
  has_many :parent_types, -> {where(relationship: "parent")}, through: :logs, foreign_key: :type_a_id, source: :type_b_id, class_name: "Type"

  def relationships
    logs = Log.where(type_a_id: self.id).where.not(relationship: nil)
    logs.map{ |log| log.relationship }
  end

end
