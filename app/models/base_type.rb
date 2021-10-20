class BaseType < ApplicationRecord
    validates :title_singular, :title_plural, uniqueness: true, presence: true
    validates :value_type, presence: true
    has_many :logs, foreign_key: :base_type_a_id, dependent: :destroy
    has_many :reverse_logs, class_name: "Log", foreign_key: :base_type_b_id, dependent: :destroy
    
    def get_datassistant
        Datassistant.find_by(id: self.datassistant_id)
    end

    def get_relatives(relationship,datassistant_id=self.datassistant_id)
        if (datassistant_id)
            logs = Log.where(base_type_a_id: self.id, datassistant_id: datassistant_id,relationship: relationship)
            logs.map{|log| BaseType.find(log.base_type_b_id)}
        end
    end

    def sub_types(datassistant_id=nil)
        self.get_relatives("child",datassistant_id)
    end

    def make_relationship(base_type,relationship,datassistant_id=self.datassistant_id)
        Log.create(
            relationship: relationship,
            base_type_a_id: self.id,
            base_type_b_id: base_type.id,
            datassistant_id: datassistant_id
        )
        Log.create(
            relationship: corresponding_relative[relationship.to_sym],
            base_type_b_id: self.id,
            base_type_a_id: base_type.id,
            datassistant_id: datassistant_id
        )
    end
    
    def make_subtype(singular,plural,datassistant_id=self.datassistant_id)
        newBaseType = BaseType.create(
            value_type: self.value_type,
            title_singular: singular,
            title_plural: plural,
            datassistant_id: datassistant_id
        )
        self.make_relationship(newBaseType,"child",newBaseType.datassistant_id)
        newBaseType
    end
    
    def parent_types
        logs = Log.where(base_type_a_id: self.id,relationship: "parent")
        logs.map{|log| BaseType.find(log.base_type_b_id)}
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

end
