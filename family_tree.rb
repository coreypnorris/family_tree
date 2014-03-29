require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  puts 'Welcome to the family tree!'
  puts 'What would you like to do?'

  loop do
    puts "\n"
    puts 'Press a to add a family member.'
    puts 'Press l to list out the family members.'
    puts 'Press m to make a marriage.'
    puts 'Press s to see who someone is married to.'
    puts "Press p to see who someone's parents are."
    puts "Press c to see someone's children."
    puts "Press g to see who someone's grandparents are."
    puts "Press k to see who someone's grandkids are."
    puts "Press q to see who someone's siblings are."
    puts 'Press e to exit.'
    choice = gets.chomp

    case choice
    when 'a'
      add_person
    when 'l'
      list
    when 'm'
      add_marriage
    when 's'
      show_marriage
    when 'p'
      show_parents
    when 'c'
      show_children
    when 'g'
      show_grandparents
    when 'k'
      show_grandkids
    when 'q'
      show_siblings
    when 'e'
      exit
    end
  end
end

def add_person
  list
  puts "Enter the number of the new person's father."
  father_choice = gets.chomp.to_i
  puts "Enter the number of the new person's mother."
  mother_choice = gets.chomp.to_i
  puts 'What is the name of the family member?'
  name = gets.chomp
  person = Person.create(:name => name)
  person.update(father_id: father_choice)
  person.update(mother_id: mother_choice)
  puts name + " the child of #{Person.find(father_choice).name} & #{Person.find(mother_choice).name} was added to the family tree.\n\n"
end

def add_marriage
  list
  puts 'What is the number of the first spouse?'
  spouse1 = Person.find(gets.chomp)
  puts 'What is the number of the second spouse?'
  spouse2 = Person.find(gets.chomp)
  spouse1.update(:spouse_id => spouse2.id)
  puts spouse1.name + " is now married to " + spouse2.name + "."
end

def list
  puts 'Here are all your relatives:'
  people = Person.all
  people.each do |person|
    puts person.id.to_s + " " + person.name
  end
  puts "\n"
end

def show_marriage
  list
  puts "Enter the number of the relative and I'll show you who they're married to."
  person = Person.find(gets.chomp)
  if person.spouse == nil
    puts "#{person.name} isn't married."
  else
    puts "#{person.name} is married to #{person.spouse.name}."
  end
end

def show_parents
  list
  puts "Enter the number of the relative and I'll show you who their parents are."
  person = Person.find(gets.chomp)
  puts "#{person.father.id}) #{person.father.name} is #{person.name}'s father"
  puts "#{person.mother.id}) #{person.mother.name} is #{person.name}'s mother"
end

def show_children
  list
  puts "Enter the number of the relative and I'll show you who their children are."
  person = Person.find(gets.chomp)
  if person.children == nil
    puts "#{person.name} has no children."
  else
    person.children.each do |child|
      puts "#{child.name} is the child of #{child.father.name} & #{child.mother.name}."
    end
  end
end

def show_grandparents
  list
  puts "Enter the number of the relative and I'll show you who their grand-parents are."
  person = Person.find(gets.chomp)
  puts "Do you want to see #{person.name}'s father's parents or mother's parents?"
  puts "Press 'f' for father's parents"
  puts "Press 'm' for mother's parents"
  puts "Press any other key to return to the main menu"
  input = gets.chomp.downcase
  if input == 'f'
    dad = Person.find(person.father_id)
    grandfather = person.grandfather(dad)
    puts "#{person.name}'s grandfather on his father's side is #{grandfather.id}33 #{grandfather.name}"
    grandmother = person.grandmother(dad)
    puts "#{person.name}'s grandmother on his father's side is #{grandmother.id} #{grandmother.name}"
  elsif input == 'm'
    mom = Person.find(person.mother_id)
    grandfather = person.grandfather(mom)
    puts "#{person.name}'s grandfather on his mother's side is #{grandfather.id} #{grandfather.name}"
    grandmother = person.grandmother(mom)
    puts "#{person.name}'s grandmother on his mother's side is #{grandmother.id} #{grandmother.name}"
  else
    menu
  end
end

def show_grandkids
  list
  puts "Enter the number of the relative."
  person = Person.find(gets.chomp)
  puts "Now, enter the number of #{person.name}'s children and I'll show you their children."
  if person.children == nil
    puts "#{person.name} has no children."
  else
    person.children.each_with_index do |child|
      puts "#{child.id} #{child.name}"
    end
    child = Person.find(gets.chomp.to_i)
    if person.grandkids(child) == nil
      puts "#{child.name} has no children."
    else
      person.grandkids(child).each do |grandkid|
        puts "#{grandkid.name} is the grandchild of #{person.name} & #{person.spouse.name}"
      end
    end
  end
end

def show_siblings

end

menu





