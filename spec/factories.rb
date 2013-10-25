FactoryGirl.define do
  sequence(:username) {|n| "name#{n}" }


  sequence(:email) {|n| "email#{n}@test.com" }


  factory :user do
    username  { generate(:username) }
    email { generate(:email) }
    
  end

  sequence(:directory_name) { |n| "name#{n}" }

  factory :directory_node do
    name { generate(:directory_name) }
  end

end

