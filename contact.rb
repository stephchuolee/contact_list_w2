class Contact < ActiveRecord::Base

  validates :firstname, presence: true 
  validates :lastname, presence: true
  validates :email, presence: true

  def to_s
    "#{id}: #{firstname} #{lastname} (#{email})"
  end

end 



