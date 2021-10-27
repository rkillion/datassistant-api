class Type < ApplicationRecord
  belongs_to :datassistant
  validates :title_singular, :title_plural, presence: true
  has_many :logs, foreign_key: :type_a_id, dependent: :destroy
  has_many :reverse_logs, class_name: "Log", foreign_key: :type_b_id, dependent: :destroy

  def relationships
    logs = Log.where(type_a_id: self.id).where.not(relationship: nil)
    logs.map{ |log| log.relationship }
  end

  def get_relatives(relationship)
    logs = Log.where(type_a_id: self.id).where(relationship: relationship)
    logs.map{|log| Type.find(log.type_b_id)}
  end

  def sub_types
    self.get_relatives("child")
  end

  def make_subtype(singular,plural)
    newType = Type.create(
      datassistant_id: self.datassistant.id,
      title_singular: singular,
      title_plural: plural
    )
    Log.create(
      datassistant_id: self.datassistant.id,
      type_a_id: newType.id,
      reference: "type",
      action: "created"
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

  # parent_path returns an array types {id: 0,title_singular: "",title_plural: ""} that are parent types of the type starting with the oldest and ending with the most recent

  def parent_types
    self.get_relatives("parent")
  end

  def parent_path
    @path = []
    @parent = self.parent_types[0]
    while @parent
      @path.unshift(@parent)
      @parent = @parent.parent_types[0]
    end
    @path
  end

  def make_instance(name)
    instance = Instance.create(
      datassistant_id: self.datassistant_id,
      name: name
    )
    Log.create(
      datassistant_id: self.datassistant.id,
      instance_a_id: instance.id,
      reference: "instance",
      action: "created"
    )
    Log.create(
      relationship: "instance",
      type_a_id: self.id,
      instance_a_id: instance.id,
      datassistant_id: self.datassistant_id
    )
    self.parent_path.each{|type|
    Log.create(
      relationship: "instance",
      type_a_id: type.id,
      instance_a_id: instance.id,
      datassistant_id: self.datassistant_id
    )}
    instance
  end

  def instances
    logs = Log.where(type_a_id: self.id).where(relationship: "instance")
    logs.map{|log| Instance.find(log.instance_a_id)}
  end

  def log_entries
    Log.where(type_a_id: self.id,reference: "type")
  end

  #assignments

  #config {action: grants many||grants one, type_b_id: 0}
  # def assign_granted_types(config)
  #   Log.create(
  #     action: config.action,
  #     type_a_id: self.id,
  #     type_b_id: config.type_b_id,
  #     datassistant_id: self.datassistant.id
  #   )
  # end

  #config {action: grants many||grants one, type_b_id: 0, to: "many"||"one"}
  def assign_granted_types(config)
    log_a = Log.create(
      action: config[:action],
      type_a_id: self.id,
      type_b_id: config[:type_b_id],
      reference: "type",
      datassistant_id: self.datassistant.id
    )
    recipient_action = "grants many"
    if config[:to]=="one"
      recipient_action = "grants one"
    end
    Log.create(
      action: recipient_action,
      type_b_id: self.id,
      type_a_id: config[:type_b_id],
      reference: "type",
      datassistant_id: self.datassistant.id
    )
    log_a
  end

  def granted_types
    logs = self.logs.where({action: ["grants many","grants one"]})
    logs.map{|log| Type.find(log.type_b_id)}
  end

end
