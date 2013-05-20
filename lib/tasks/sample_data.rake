namespace :db do 
  desc "Fill database with sample data"
  task populate: :environment do
    #create和create!的区别是，create!发生错误的时候抛出异常，而create则返回false
    admin = User.create!(name: "Example User",
                 email: "example@163.com",
		 password: "foobar",
		 password_confirmation: "foobar")
   admin.toggle!(:admin)
     99.times do |n|
       name = Faker::Name.name
       email = "example-#{n-1}@163.com"
       password = "password"
       User.create!(name: name,
                    email: email,
		    password: password,
		    password_confirmation: password)
     end
  end
end
