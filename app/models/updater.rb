require 'json'
module Updater

  class Updater
  end

  # github updater to update the github task
  class GithubUpdater < Updater
    def self.update?
      true
    end

    def self.check_event event
      nil
    end
  end

  # pivotal updater to update the github task
  class PivotalUpdater < Updater
    def self.update?
      true
    end

    def self.check_event event
      nil
    end
  end

  # local updater to update the github task
  class LocalUpdater < Updater
    def self.update?
      true
    end

    def self.check_event event
      nil
    end
  end

end
