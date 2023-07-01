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
    self.where(first: 'Candice')
  end
  def self.with_valid_email
    self.where('email LIKE ?', '%@%')
  end
  def self.with_dot_org_email
    self.with_valid_email.where('email LIKE ?', '%.org')
  end
  def self.with_invalid_email
    self.where('email NOT LIKE ?', '%@%')
  end
  def self.with_blank_email
    self.where(email: nil)
  end
  def self.born_before_1980
    self.where('birthdate < ?', Date.parse('1980-01-01'))
  end
  def self.with_valid_email_and_born_before_1980
    self.with_valid_email.born_before_1980
  end
  def self.last_names_starting_with_b
    self.where('last LIKE ?', 'B%').order('birthdate')
  end
  def self.twenty_youngest
    self.order(birthdate: :desc).limit(20)
  end
  def self.update_gussie_murray_birthdate
    self.find_by(first: 'Gussie').update(birthdate: Date.parse('2004-02-08'))
  end
  def self.change_all_invalid_emails_to_blank
    self.with_invalid_email.update_all(email: nil)
  end
  def self.delete_meggie_herman
    self.find_by(:first => 'Meggie', :last => 'Herman').destroy
  end
  def self.delete_everyone_born_before_1978
    self.where('birthdate < ?', Date.parse('1978-01-01')).destroy_all
  end
  # etc. - see README.md for more details
end
