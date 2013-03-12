class User < ActiveRecord::Base
  attr_accessible :display_name, :email, :uid

  has_many :ledgers
end
