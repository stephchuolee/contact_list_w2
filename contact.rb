require 'pg'

class Contact

  CONN = PG.connect(
    host: 'localhost',
    dbname: 'contacts', 
    user: 'development',
    password: 'development'
    port: 5432
    )

  attr_reader :firstname, :lastname, :email, :id 

  def initialize (firstname, lastname, email, id=0)
    @firstname = firstname 
    @lastname = lastname
    @email = email
    @id = id if id > 0
  end 

  def save
    if id > 0 
      query = "UPDATE contacts SET firstname = 'firstname', lastname = 'lastname', email = 'email' WHERE id = @id"#is @ necessary?
    else 
      query = "INSERT INTO contacts(firstname, lastname, email) VALUES('#{firstname}','#{lastname}', '#{email}') RETURNING id;"
      id = #id returned from query 
    end 
  end 

  def destroy
    query = "DELETE FROM contacts WHERE id = #{id}"
  end 

  def self.find(id)
    query = "SELECT c.id, c.firstname, c.lastname, c.email FROM contacts AS c WHERE c.id = #{id}"

  end 

  def self.find_all_by_lastname(name)

  end 

  def self.find_all_by_firstname(name)
  end 

  def find_by_email(email)
  end 

end 

