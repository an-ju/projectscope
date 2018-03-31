require 'json'
module Updater

  class Updater
  end

  # github updater to update the github task
  class GithubUpdater < Updater
    def self.update
      # Here we are going to call event api in the future and receive call back
      check_event
    end

    def self.check_event
      true
    end

    def self.analysis_call_back githubdata
      nil
    end
  end

  # pivotal updater to update the github task
  class PivotalUpdater < Updater
    def self.update
      check_event
    end

    def self.check_event
      true
    end

    def self.analysis_call_back pivotaldata
      nil
    end
  end

  # local updater to update the github task
  class LocalUpdater < Updater
    def self.update
      check_event
    end

    def self.check_event
      true
    end

    def self.analysis_call_back localdata
      nil
    end
  end

end
