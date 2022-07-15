# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

service = User::Authentication.register({
  first_name: "Tarek",
  last_name: "Elmasri",
  email: "dr.tareqelmasry@hotmail.com",
  phone_no: "547114896",
  password: "12345@Aa",
  rule: "admin",
  gender: "male"
})
