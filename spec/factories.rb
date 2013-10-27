FactoryGirl.define do
  sequence(:username) {|n| "name#{n}" }


  sequence(:email) {|n| "email#{n}@test.com" }


  factory :user do
    username  { generate(:username) }
    email { generate(:email) }
    password { "testerama" }
    
  end

  sequence(:directory_name) { |n| "dir-name#{n}" }
  sequence(:file_name) { |n| "name#{n}.txt" }

  factory :directory_node do
    name { generate(:directory_name) }
  end

  factory :file_node_content do
    content_type "text/plain"
    content "This is the text file content"
  end

  factory :file_node do |fn|
    name { generate(:file_name) }
    file_type "text"

    association(:file_node_content) { |fn| build(:file_node_content) if fn.file_type == "text" }
  end

end

