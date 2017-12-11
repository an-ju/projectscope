class StudentTask < ActiveRecord::Base
    has_many :parents, class_name: "StudentTask"
    belongs_to :iteration
    belongs_to :project
    has_many :comments
    def add_parent(p)
        self.parents.push(p)
        self.save
    end
    def depth
        min = 0
        self.parents.each do |p|
            tmp = 1 + p.depth
            if tmp>min
                min=tmp
            end
        end
        return min
    end
    def self.level_search(iter_id,team_id)
        tasks = StudentTask.where('iteration_id': iter_id, 'project_id': team_id)
        
        result = []
        tasks.each do |t|
            
            level = t.depth
            puts level 
            if result[level].nil?
                result[level]=[]
            end
            result[level].push(t)
            puts result[level]
        end
        puts result.length
        return result
    end
  
    def self.topological_sort(iter_id,team_id)
        tasks = StudentTask.where('iteration_id': iter_id, 'project_id': team_id)
        result = []
        while result.length < tasks.length do
            tasks.each do|t|
                if !result.include?(t)&&t.not_block?(result)
                    result.push(t)
                end
            end
        end
        return result
    end
    def not_block?(exist_task)
        self.parents.each do |p|
            if !exist_task.include?(p)
                return false
            end
        end
        return true
    end

    def get_parents
        self.parents.map {|p| "\"#{p.title}\""}.join(',')
    end
    def is_blocked
        if self.parents.empty?
            return false
        else
            self.parents.each do |p|
                if p.status != "Finished"
                    return true
                end
            end
            return false
        end
        
    end
end
