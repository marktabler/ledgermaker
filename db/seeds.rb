# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

l = Ledger.find_or_create_by_title(title: "Sample Ledger")

def t(ledger, values)
  ledger.transactions.create(values)
end

def dom(day_of_month)
  Date.today.beginning_of_month + (day_of_month - 1).days
end

internet = t l, title: "Comcast", date: dom(5), value: 88.50
