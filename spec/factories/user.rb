FactoryBot.define do
  factory :admin, class: User do
    provider_username { 'Admin' }
    uid { 'uadmin' }
    email { 'uadmin@example.com' }
    provider { 'developer' }
    role { User::ADMIN }
    password { Devise.friendly_token[0,20] }
  end

  factory :student, class: User do
    provider_username { 'Student' }
    uid { 'ustudent' }
    email { 'ustudent@example.com' }
    provider { 'developer' }
    role { User::STUDENT }
    password { Devise.friendly_token[0,20] }
  end
end