FactoryBot.define do
  factory :fake_mentee, class: 'User' do
    first_name { "John" }
    last_name { "Doe" }
    email { "johndoe2@example.com" }
    encrypted_password { Devise::Encryptor.digest(User, 'password') }
    country { "Brazil" }
    city { "São Paulo" }
    state { "SP" }
    professional_field { "Tecnologia" }
    academic_degree { "Ciências da Computação" }
    mentor { false }
  end

  factory :fake_mentor, class: 'User' do
    first_name { "Jane" }
    last_name { "Doe" }
    email { "janedoe@example.com" }
    encrypted_password { Devise::Encryptor.digest(User, 'password') }
    country { "Brazil" }
    city { "Rio de Janeiro" }
    state { "RJ" }
    professional_field { "Negócios" }
    academic_degree { "Administração" }
    mentor { true }
  end
end
