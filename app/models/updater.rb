module Updater

  # begin
  #  create_table "updaters", force: :cascade do |t|
  #    t.integer  "task_id"
  #    t.string   "updater_type"
  #    t.datetime "created_at",   null: false
  #    t.datetime "updated_at",   null: false
  #    t.integer  "event_id"   which is going to be in after the event interface being inplemented
  #  end
  # end
  # this is a updater which we use to get the Events chain and update the info.
  mattr_accessor :update_type
  class Updater < ActiveRecord::Base
    belongs_to :task
    validates :updater_type, presence: true, inclusion: %w(LocalUpdater GithubUpdater PivotalUpdater)

    # When the event module is successfully built, we'll check the status here
    # Redifine the Ruby initializer to accomplish the strategy method, the updater come with the initialize
    # is the updater we are going to use for each task
    def status_check
      pass
    end

    def check
     pass
    end
  end

  class LocalUpdater < Updater
    def initialize
      super
      self.updater_type = "LocalUpdater"
    end

    def status_check
      puts "this is local updater"
    end
  end

  class GithubUpdater < Updater
    def initialize
      super
      self.updater_type = "GithubUpdater"
    end
    def status_check
      puts "this is GithubUpdater"
    end
  end

  class PivotalUpdater < Updater
    def initialize
      super
      self.updater_type = "PivotalUpdater"
    end
    def status_check
      puts "this is pivotalUpdater"
    end
  end
end
