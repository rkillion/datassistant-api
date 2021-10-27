class Instance < ApplicationRecord
  belongs_to :datassistant
  validates :name, presence: true
  has_many :logs, foreign_key: :instance_a_id, dependent: :destroy
  has_many :reverse_logs, class_name: "Log", foreign_key: :instance_b_id, dependent: :destroy
  
  def parents
    logs = Log.where(instance_a_id: self.id).where(relationship: "instance")
    logs.map{|log| Type.find(log.type_a_id)}
  end

  def parent_path
    self.parents.sort{|a,b| a.parent_path.length <=> b.parent_path.length}
  end

  def log_entries
    Log.where(instance_a_id: self.id,reference: "instance")
  end

  #assignments

  #config {instance_b_id, type_a_id, type_b_id}
  def assign_instance(config)
    log_a = Log.create(
      action: "has",
      instance_a_id: self.id,
      instance_b_id: config[:instance_b_id],
      type_b_id: config[:type_b_id],
      reference: "instance",
      datassistant_id: self.datassistant.id
    )
    Log.create(
      action: "has",
      instance_b_id: self.id,
      instance_a_id: config[:instance_b_id],
      type_b_id: config[:type_a_id],
      reference: "instance",
      datassistant_id: self.datassistant.id
    )
    log_a
  end

  def instances_owned
    logs = self.logs.where(action: "has")
    logs.map do |log|
      instance = Instance.find(log.instance_b_id)
      {
        id: instance.id,
        name: instance.name,
        type_id: log.type_b_id
      }
    end
  end

end
