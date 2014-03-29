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

  def children
    children = []
    children << Person.where( father_id: self.id )
    children << Person.where( mother_id: self.id )
    children.flatten!
    if children.length == 0
      children = nil
    else
      children
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

  def grandkids(child)
    grandkids = []
    if child.children == nil
      nil
    else
      child.children.each { |grandkid| grandkids << grandkid }
      grandkids
    end
  end

  def siblings
    siblings = []
    siblings << Person.where( father_id: self.father_id, mother_id: self.mother_id).where.not(id: self.id )
    siblings.flatten!
    if siblings.length == 0
      siblings = nil
    else
      siblings
    end
  end

private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
