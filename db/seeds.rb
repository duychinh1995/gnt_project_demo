User.create!(name:  "Duy Chinh",
             email: "hduychinh@gmail.com",
             address: "1/27 Luong Dac Bang P Tan Thoi Hoa Q Tan Phu",
             phone: "0909090909",
             gender: "male",
             password: "123123",
             password_confirmation: "123123",
             role: 0,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  phone = Faker::Number.number(2)
  gender = "female"
  address = Faker::Address.street_address
  User.create!(name:  name,
               phone: phone,
               gender: gender,
               email: email,
               address: address,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

10.times do |n|
  title  = Faker::Book.genre
  catcontent = Faker::Lorem.sentence
  status = 1
  Category.create!(title:  title,
               catcontent: catcontent,
               status: status)
end

50.times do |n|
  productname  = Faker::Book.title
  price = Faker::Commerce.price
  discount = Faker::Number.between(5, 20)
  onhand = Faker::Number.between(5, 100)
  productcontent = Faker::Lorem.paragraph
  author = Faker::Book.author
  image = Faker::Avatar.image
  status = 1
  category_id = Faker::Number.between(1, 10)
  Product.create!(productname:  productname,
               price: price,
               discount: discount,
               onhand: onhand,
               productcontent: productcontent,
               author: author,
               image: image,
               status: status,
               category_id: category_id)
end

10.times do |n|
  code  = Faker::Code.asin
  discount = Faker::Number.between(5, 20)
  user_id = Faker::Number.between(2, 100)
  Giftcode.create!(code:  code,
               discount: discount,
               user_id: user_id)
end

25.times do |n|
  totalamount  = Faker::Number.number(5)
  giftcode_id = Faker::Number.between(1, 10)
  user_id = Faker::Number.between(2, 100)
  status = Faker::Number.between(0, 4)
  Order.create!(totalamount:  totalamount,
               giftcode_id: giftcode_id,
               user_id: user_id,
               status: status)
end

25.times do |n|
  quantity  = Faker::Number.between(1, 5).to_i
  unitprice = Faker::Number.number(5).to_i
  discount = Faker::Number.between(5, 20)
  amount = quantity * unitprice
  product_id = Faker::Number.between(1, 50)
  order_id = Faker::Number.between(1, 25)
  OrderDetail.create!(quantity:  quantity,
               unitprice: unitprice,
               discount: discount,
               amount: amount,
               product_id: product_id,
               order_id: order_id)
end
