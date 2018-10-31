FactoryBot.define do
  factory :task do
    title { 'Test Title' }
    trait :github do
      task_status { 'started' }
      updater_type { 'github' }
      title { 'test task' }
    end

    trait :pivotal do
      task_status { 'started' }
      updater_type { 'pivotal' }
      title { 'test task' }
    end

    trait :local do
      task_status { 'started' }
      updater_type { 'local' }
      title { 'test task' }
    end

    trait :requesting do
      task_status { 'started' }
      updater_type { 'requesting' }
      title { 'test task' }
    end

    trait :planning do
      task_status { 'started' }
      updater_type { 'planning' }
      title { 'test task' }
    end

    trait :execution do
      task_status { 'started' }
      updater_type { 'execution' }
      title { 'test task' }
    end

    trait :delivering do
      task_status { 'started' }
      updater_type { 'delivering' }
      title { 'test task' }
    end

    trait :started do
      task_status { 'started' }
    end

    trait :finished do
      task_status { 'finished' }
    end

    trait :danger do
      task_status { 'danger' }
    end

    trait :unstarted do
      task_status { 'unstarted' }
    end

  end
end