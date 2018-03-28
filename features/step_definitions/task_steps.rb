Given(/^the following task graph configs:$/) do |table|
  table.hashes.each do |hash|
    newiter = Iteration.new()
    newiter.name = hash['name']
    newiter.project_id = Project.find_by_name(hash['project']).id
  end
end