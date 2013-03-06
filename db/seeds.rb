# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Running seeds"

l = Ledger.create(title: "Test Ledger")

current = l.transactions.create(value: 123.45, title: "Current: One Twenty-Three and Forty Five Cents", date: DateTime.now - 1.year)
projected = l.transactions.create(value_in_cents: 4567, title: "Projected: Forty-five and Sixty Seven Cents", date: DateTime.now + 1.year)
