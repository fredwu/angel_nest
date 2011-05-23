require 'machinist/active_record'

User.blueprint do
  name     { 'John Doe' }
  email    { 'test@example.com' }
  password { 'password' }
end