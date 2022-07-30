
admin_user = User::Authentication.register({
  first_name: "Tarek",
  last_name: "Elmasri",
  email: "dr.tareqelmasry@hotmail.com",
  phone_no: "547114896",
  password: "12345@Aa",
  rule: "admin",
  gender: "male"
  })

Current.user = admin_user
  
staff_user = User::Authentication.register({
  first_name: "TarekStaff",
  last_name: "Elmasri",
  email: "tito4g@gmail.com",
  phone_no: "547114895",
  password: "12345@Aa",
  rule: "staff",
  gender: "male"
})

regular_user = User::Authentication.register({
  first_name: "TarekUser",
  last_name: "Elmasri",
  email: "tarek@gmail.com",
  phone_no: "547114894",
  password: "12345@Aa",
  gender: "male"
  })
  #------------
  # Categories
  cards_category = Category::CategoryCreation.new(
    name: 'Degitial Cards',
    pinned: true
  ).create!

  #-----------------------
  # items
  
item1 = Item::ItemCreation.new(
  name: 'Yamaha Guitar',
  type_name: 'item',
  has_limited_stock: true,
  allow_multi_quantity: true,
  stock: 12,
  price: 1266.99,
  available: true
).create!

item2 = Item::ItemCreation.new(
  name: 'Playstation 5',
  type_name: 'item',
  has_limited_stock: true,
  allow_multi_quantity: true,
  stock: 6,
  price: 2499.99,
  available: true,
  notify_on_low_stock: true,
  low_stock: 5
).create!

item3 = Item::ItemCreation.new(
  name: '50$ pubg card',
  type_name: 'card',
  allow_multi_quantity: true,
  has_limited_stock: true,
  price: 36.99,
  notify_on_low_stock: true,
  low_stock: 1,
  available: true,
  item_categories_attributes:[
    {category_id: cards_category.id}
  ]
).create!

item4 = Item::ItemCreation.new(
  name: '10$ itunes card',
  type_name: 'card',
  notify_on_low_stock: true,
  has_limited_stock: true,
  low_stock: 2,
  allow_multi_quantity: true,
  price: 9.99,
  available: true,
  item_categories_attributes:[
    {category_id: cards_category.id}
  ]
).create!

item5 = Item::ItemCreation.new(
  name: 'Stickers',
  type_name: 'item',
  has_limited_stock: false,
  allow_multi_quantity: true,
  price: 1.99,
  available: true
).create!
 


#------
# cards for degital cards
card1 = Card::CardCreation.new(
  item_id: item3.id,
  code: 'HgxYIlMk60uIs54MNbQSa'
).create!

card2 = Card::CardCreation.new(
  item_id: item3.id,
  code: 'MMMMLLLLKKKK6766aabb'
).create!

card3 = Card::CardCreation.new(
  item_id: item3.id,
  code: 'MKOGSDLMJwwwwwwwwwww'
).create!

card4 = Card::CardCreation.new(
  item_id: item3.id,
  code: 'IMKJHGJL1LKJHG111111'
).create!

card5 = Card::CardCreation.new(
  item_id: item4.id,
  code: '10$CARDcodeMMMM'
).create!

card6= Card::CardCreation.new(
  item_id: item4.id,
  code: '10$CARDcode222222222'
).create!

card7 = Card::CardCreation.new(
  item_id: item4.id,
  code: '10$CARDcodeMMMM333333'
).create!
 