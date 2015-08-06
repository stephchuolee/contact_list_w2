require 'pg'
require 'pry'
require_relative './setup'
require_relative './contact'


# TODO: Implement command line interaction
# This should be the only file where you use puts and gets

def help_menu
puts "Here is a list of available commands:
  new  - Create a new contact
  list - List all contacts
  show - Show a contact 
  find - Find a contact"
end 


def new_contact
  puts "Please input an email address for the new contact"
  email = STDIN.gets.chomp.to_s
  if Contact.exists?(email: "#{email}") #how to do this with "?" and what is this called ?
    puts "This email already exists in the database."
  else 
    puts "Please input a first name:"
    firstname = STDIN.gets.chomp.to_s
    puts "Please input a last name:"
    lastname = STDIN.gets.chomp.to_s
  end 
  Contact.create(firstname: firstname, lastname: lastname, email: email)
end 

def list_all 
  list =  Contact.all 
  list.each do |contact| 
    puts contact
  end 
  puts "--"
  puts "#{Contact.count} records total"
end 

def find_by_id
  puts "What is the id of the person you would like to find?"
  id_to_find = STDIN.gets.chomp.to_i
  contact_exists = Contact.exists?(id_to_find)
  if contact_exists 
    contact = Contact.find(id_to_find)
    puts contact
  else 
    puts "ID ##{id_to_find} doesn't exist."
  end 
end 

def find_contact
  puts "Would you like to search by first name, last name, or by email?" 
  input = STDIN.gets.chomp.to_s

  case input 
    when "first name" 
      puts "Enter a first name:"
      name = STDIN.gets.chomp.to_s
      contact = Contact.where("LOWER(firstname) LIKE LOWER(?)", "%#{name}%")
      puts contact
    when "last name"
      puts "Enter a last name:"
      name = STDIN.gets.chomp.to_s
      contact = Contact.where("LOWER(lastname) LIKE LOWER(?)", "%#{name}%")
      puts contact
    when "email" 
      puts "Enter an email"
      email = STDIN.gets.chomp.to_s
      contact = Contact.where("LOWER(email) LIKE LOWER(?)", "%#{email}%")
      puts contact
  end 

end 


if ARGV.empty? 
  ARGV << "help"
end 
  
command = ARGV[0]
 
case command 
  when "help" then help_menu
  when "new" then new_contact
  when "list" then list_all
  when "show" then find_by_id
  when "find" then find_contact
end 