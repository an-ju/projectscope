FactoryGirl.define do
  factory :task do
    factory :githubtask do
      title 'githubtask'
      updater_type 'github'
    end

    factory :pivotaltask do
      title 'pivotaltask'
      updater_type 'pivotal'
    end

    factory :localtask do
      titile 'localtask'
      updater_type 'local'
    end
  end
end