require 'json'
module Updater

  class Updater
  end

  # github updater to update the github task
  class GithubUpdater < Updater
    def self.update task,value
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
    def self.update task,value
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
    def self.update task, value
      if (value == 'true')
        task.update_attributes(task_status: 'finished')
      end
    end

    def self.check_event
      true
    end

    def self.analysis_call_back localdata
      nil
    end
  end

end
