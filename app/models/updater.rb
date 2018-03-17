module Updater

  # begin
  #  create_table "updaters", force: :cascade do |t|
  #    t.integer  "task_id"
  #    t.string   "updater_type"
  #    t.datetime "created_at",   null: false
  #    t.datetime "updated_at",   null: false
  #  end
  # end
  # this is a updater which we use to get the Events chain and update the info.

  class Updater < ActiveRecord::Base
    belongs_to :task
    validates :updater_type, presence: true, inclusion: %w(LocalUpdater GithubUpdater PivotalUpdater)

    # Redifine the Ruby initializer to accomplish the strategy method, the updater come with the initialize
    # is the updater we are going to use for each task
  end

  class LocalUpdater < Updater

  end

  class GithubUpdater < Updater

  end

  class PivotalUpdater < Updater

  end
end
