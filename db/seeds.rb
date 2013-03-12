# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
u = User.find_or_create_by_uid(uid: "TEST", display_name: "TESTER", email: "foo@bar.com")
l = Ledger.find_or_create_by_title(title: "Sample Ledger", user_id: u.id)

def t(ledger, values)
  ledger.transactions.create(values)
end

def dom(day_of_month)
  Date.today.beginning_of_month + (day_of_month - 1).days
end

internet = t l, title: "Comcast", date: dom(5), value: -88.50
rent = t l, title: "Rent", date: dom(1), value: -1200.00
car_insurance = t l, title: "Car Insurance", date: dom(14), value: -140.00
weekly_food_budget = t l, title: "Groceries", date: dom(1), value: -150.00
paycheck = t l, title: "Paycheck", date: dom(3), value: 2000

starting_balance = t l, title: "Starting Balance", date: rent.date - 1.month, value: 2600

internet.recur(:month, 12)
rent.recur(:month, 12)
car_insurance.recur(:month, 12)
weekly_food_budget.recur(:week, 52)
paycheck.recur(:biweek, 26)
