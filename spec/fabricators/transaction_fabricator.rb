Fabricator(:transaction) do
  title { sequence(:title) { |i| "Test Transaction #{i}" } }
  value_in_cents 10000
  ledger
  date { DateTime.parse("May 28 2012") }
end