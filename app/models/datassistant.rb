class Datassistant < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, uniqueness: {scope: :user, message: "already exists"}
  has_many :types, dependent: :destroy

  def populate
    input_field = new_type("Input Field","Input Fields")
    person = new_type("Person","People")
    places = new_type("Place","Places")
    thing = new_type("Thing","Things")
    idea = new_type("Idea","Ideas")
  end

  def new_type(singular,plural)
    Type.create(
      datassistant_id: self.id,
      title_singular: singular,
      title_plural: plural
    )
  end

end
