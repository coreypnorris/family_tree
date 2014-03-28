class Person < ActiveRecord::Base
  validates :name, :presence => true

  after_save :make_marriage_reciprocal


  def spouse
    if spouse_id.nil?
      nil
    else
      Person.find(spouse_id)
    end
  end

  def child
    if child_id.nil?
      nil
    else
      Person.find(child_id)
    end
  end

  def father
    Person.find(father_id)
  end

  def mother
    Person.find(mother_id)
  end

  def grandfather(parent)
    Person.find(parent.father_id)
  end

  def grandmother(parent)
    Person.find(parent.mother_id)
  end

private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
