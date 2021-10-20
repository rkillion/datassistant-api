class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def corresponding_relative
    {
        parent: "child",
        child: "parent"
    }
  end  
  
end
