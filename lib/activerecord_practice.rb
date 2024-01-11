require 'sqlite3'
require 'active_record'
require 'byebug'


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    self.where(first: "Candice")
    # probably something like:  Customer.where(....)
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    self.where("email LIKE ?", "%@%")
  end
  # etc. - see README.md for more details

  def self.with_dot_org_email
    self.where("email LIKE ?", "%.org")
  end

  def self.with_invalid_email
    self.where.not("email LIKE ?", "%@%")
  end

  def self.with_blank_email
    self.where(email: nil)
  end
  
  def self.born_before_1980
    self.where("birthdate < ?", Time.new(1980,1,1))
  end

  def self.with_valid_email_and_born_before_1980
    self.where("email LIKE ? AND birthdate < ?", "%@%", Time.new(1980,1,1))
  end

  def self.last_names_starting_with_b
    self.where("last LIKE ?", "B%").sort_by(&:birthdate)
  end

  def self.twenty_youngest
    self.order(birthdate: :desc).limit(20)
  end

  def self.update_gussie_murray_birthdate
    self.update(birthdate: Time.parse("2004-2-8"))
  end

  def self.change_all_invalid_emails_to_blank
    self.update(email: nil)
  end

  def self.delete_meggie_herman
    self.update(first: nil, last: nil)
  end

  def self.delete_everyone_born_before_1978
    self.destroy_all
  end
end

