require 'json'
module Updater

  class Updater
  end

  # github updater to update the github task
  class GithubUpdater < Updater
    def self.update task,key,value
      # Here we are going to call event api in the future and receive call back
      task.update_attributes(task_status: 'finished')
    end

    def self.analysis_call_back githubdata
      nil
    end
  end

  # pivotal updater to update the github task
  class PivotalUpdater < Updater
    def self.update task,key,value
      task.update_attributes(task_status: 'finished')
    end

    def self.analysis_call_back pivotaldata
      nil
    end
  end

  # local updater to update the github task
  class LocalUpdater < Updater
    def self.update task, key, value
      if (value == 'true' and task.title == key)
        task.update_attributes(task_status: 'finished')
      end
    end

    def self.analysis_call_back localdata
      nil
    end
  end
  # The updaters catogorize by phase: requesting planning execution delivering
  # currently doing no checking
  class RequestingUpdater < Updater
    def self.update task, key, value
      if (value == 'true' and task.title == key)
        task.update_attributes(task_status: 'finished')
      end
    end

    def self.analysis_call_back localdata
      nil
    end
  end

  class PlanningUpdater < Updater
    def self.update task, key, value
      if (value == 'true' and task.title == key)
        task.update_attributes(task_status: 'finished')
      end
    end

    def self.analysis_call_back localdata
      nil
    end
  end

  class ExecutionUpdater < Updater
    def self.update task, key, value
      if (value == 'true' and task.title == key)
        task.update_attributes(task_status: 'finished')
      end
    end

    def self.analysis_call_back localdata
      nil
    end
  end

  class DeliveringUpdater < Updater
    def self.update task, key, value
      if (value == 'true' and task.title == key)
        task.update_attributes(task_status: 'finished')
      end
    end

    def self.analysis_call_back localdata
      nil
    end
  end

  class TestingUpdater < Updater
    def self.update task, key, value
      if (value == 'true' and task.title == key)
        task.update_attributes(task_status: 'finished')
      end
    end

    def self.analysis_call_back localdata
      nil
    end
  end

end
