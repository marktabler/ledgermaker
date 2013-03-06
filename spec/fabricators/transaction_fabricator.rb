Fabricator(:transaction) do
  title 'Test Transaction'
  value_in_cents 10000
  ledger
  date { DateTime.parse("May 5 2012") }
end