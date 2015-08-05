require 'pg'
require 'pry'

class Contact

  attr_accessor :firstname, :lastname, :email, :id 

  @@connection = nil

  def initialize (firstname, lastname, email, id=0)
    @firstname = firstname 
    @lastname = lastname
    @email = email
    @id = id if id.to_i > 0
  end 

  def to_s
    "The contact's name is #{firstname} #{lastname}. Their email is #{email}. Their ID is #{id}."
  end 

  def save
    if id #if an id already exists for the contact object
      # code commented out below is method of passing query as demonstrated in lecture, only here for reference
      # query = "UPDATE contacts SET firstname = 'firstname', lastname = 'lastname', email = 'email' WHERE id = id;"
      # @@connection.exec(query)
      Contact.connection.exec_params('UPDATE contacts SET firstname = $1, lastname = $2, email = $3 WHERE id = $4;', [firstname, lastname, email, id])

    else 
      # code commented out below is method of passing query as demonstrated in lecture, only here for reference
      # query = "INSERT INTO contacts(firstname, lastname, email) VALUES('#{firstname}','#{lastname}', '#{email}') RETURNING id;"
      # result = Contact.connection.exec(query)
      
      result = Contact.connection.exec_params('INSERT INTO contacts(firstname, lastname, email) VALUES($1, $2, $3) RETURNING id', [firstname, lastname, email])
      id = result[0]["id"] 

    end 
  end 

  def destroy
    # code commented out below is method of passing query as demonstrated in lecture, only here for reference
    # query = "DELETE FROM contacts WHERE id = #{id}"
    # Contact.connection.exec(query)
    Contact.connection.exec_params('DELETE FROM contacts WHERE id = $1', [id])
  end 

  def self.find(id)
    # code commented out below is method of passing query as demonstrated in lecture, only here for reference
    # query = "SELECT c.id, c.firstname, c.lastname, c.email FROM contacts AS c WHERE c.id = #{id}"
    # result = self.connection.exec(query)
    result = self.connection.exec_params('SELECT * FROM contacts WHERE id = $1', [id])
    person = nil
    result.each do |contact|
      person = self.new(contact["firstname"], contact["lastname"], contact["email"], contact["id"])
    end 
    person
  end 


  def self.find_all_by_lastname(name)
    query = "SELECT * FROM contacts WHERE lastname = '#{name}';" 
    result = Contact.connection.exec(query)
    # can't figure out how to convert the query code above into the exec_params version: 
    # result = self.connection.exec_params('SELECT * FROM contacts WHERE lastname = $1;', [lastname])
    result.map do |contact|
      self.new(contact["firstname"], contact["lastname"], contact["email"], contact["id"])
    end
  end 


  def self.find_all_by_firstname(name)
    query = "SELECT * FROM contacts WHERE firstname = '#{name}';" 
    result = Contact.connection.exec(query)
    result.map do |contact|
      self.new(contact["firstname"], contact["lastname"], contact["email"], contact["id"])
    end 
  end 

  def self.find_by_email(email)
    query = "SELECT * FROM contacts WHERE email = '#{email}' LIMIT 1;" 
    result = Contact.connection.exec(query)
    person = nil 
    result.each do |contact|
      person = self.new(contact["firstname"], contact["lastname"], contact["email"], contact["id"])
    end 
    person 
  end 


  def self.connection
    if @@connection 
      @@connection #return 
    else 
      @@connection = PG.connect(
        host: 'localhost',
        dbname: 'contacts', 
        user: 'development',
        password: 'development',
        port: 5432)
    end
  end


end 

