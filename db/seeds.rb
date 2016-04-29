require 'random_data'

# Create users
5.times do |i|
  User.create!(
    name: "#{i}_" + RandomData.random_word,
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

# Create wikis
35.times do |i|
  Wiki.create!(
    title: "#{i}_" + RandomData.random_sentence,
    body: RandomData.random_paragraph,
    user: users.sample,
    private: rand(1..4) == 1 # 1/4 of created wikis will be private
  )
end
wikis = Wiki.all
puts "#{wikis.count} wikis created."

puts "Seed finished"
