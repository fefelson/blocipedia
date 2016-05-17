require 'random_data'

# Create users
20.times do |i|
  User.create!(
    name: "#{i}_" + RandomData.random_word,
    email: RandomData.random_email,
    password: 'password',
    role: :standard
  )
end

unless User.find_by(email: 'admin@example.com')
  User.create!(
    name: 'admin',
    email: 'admin@example.com',
    password: 'helloworld',
    role: :admin
  )
end

users = User.all
puts "#{users.count} users created."

# Create wikis
35.times do |i|
  wiki = Wiki.new(
    title: "#{i}_" + RandomData.random_sentence,
    body: RandomData.random_paragraph,
    user: users.sample,
    private: rand(1..4) == 1 # 1/4 of created wikis will be private
  )
  other_users = users - [wiki.user]
  wiki.users = other_users.sample(rand(0..5))
  wiki.save
  puts wiki.users.count
end
wikis = Wiki.all
puts "#{wikis.count} wikis created."

puts "Seed finished"
