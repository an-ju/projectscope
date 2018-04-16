FactoryGirl.define do
  factory :task do
    task_status 'started'
    title 'Test Title'
    trait :github do
      updater_type 'github'
    end

    trait :pivotal do
      updater_type 'pivotal'
    end

    trait :local do
      updater_type 'local'
    end

    trait :preliminary do
      updater_type 'preliminary'
    end
  end
end