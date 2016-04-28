require 'random_data'

# Create users
5.times do |i|
  User.create!(
    name: "#{i} " + RandomData.random_word,
    email: RandomData.random_email,
    password: 'password'
  )
end

unless User.find_by(email: 'admin@example.com')
  User.create!(
    name: 'admin',
    email: 'admin@example.com',
    password: 'helloworld'
  )
end

users = User.all
puts "#{users.count} users created."

puts "Seed finished"
