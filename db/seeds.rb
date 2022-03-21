# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user= User.new(first_name: "tarek", last_name: "elmasri" , password: '12345' , phone_no: "547114896", gender: "male", email: "tarek@gmail", rule: "user")
user.save

user2=User.new(first_name: "admin" , last_name: "account" , password: "12345" , email:"admin@gmail.com" , phone_no: "547114897", gender:"male", rule: "admin")
user2.save

user3=User.new(first_name: "staff" , last_name: "account" , password: "12345" , email:"staff@gmail.com" , phone_no: "547114899", gender:"male", rule: "staff")
user3.save