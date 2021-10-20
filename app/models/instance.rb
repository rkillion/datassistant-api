class Instance < ApplicationRecord
  belongs_to :datassistant
  has_many :logs, foreign_key: :instance_a_id, dependent: :destroy
  has_many :reverse_logs, class_name: "Log", foreign_key: :instance_b_id, dependent: :destroy
  
end
