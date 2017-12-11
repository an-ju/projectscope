Given(/the following iterations exist:/) do |iterations_table|
  iterations_table.hashes.each do |iteration|
    
    i = Iteration.create!(name: iteration["iteration_name"],
                          start: Date.today,
                          end: Date.tomorrow,
                          created_at: DateTime.now)
  end
end

Given(/the following tasks exist:/) do |task_table|
  
  puts(Project.where(name: "Project_1").first.id)
  
  task_table.hashes.each do |task|
    p_id = Project.where(name: "Project_1").first.id
    i_id = Iteration.where(name: "iteration_01").first.id
    
    i = StudentTask.create!(iteration_id: i_id,
                            title: task["title"],
                            description: "test generated Student Task",
                            created_at: Date.today,
                            project_id: p_id
                            )
  end
end

When /^(?:|I )fill in the box for general comment with "([^"]*)"$/ do |cmnt|
  within("form#general_metric_1_form",  visible: false) do
    fill_in("content", :with => cmnt,  visible: false)
  end
end

When /^(?:|I )submit general comment form$/ do 
  within("form#general_metric_1_form",  visible: false) do
    click_button("Reply",  visible: false)
  end
end

When /^(?:|I )submit iteration comment form$/ do 
  within("form#iteration_1_form",  visible: false) do
    click_button("Reply",  visible: false)
  end
end

When /^(?:|I )fill in the box for iteration comment with "([^"]*)"$/ do |cmnt|
  within("form#iteration_1_form",  visible: false) do
    fill_in("content", :with => cmnt,  visible: false)
  end
end


When /^(?:|I )submit task comment form$/ do 
  within("form#task_1_form",  visible: false) do
    click_button("Reply",  visible: false)
  end
end

When /^(?:|I )fill in the box for task comment with "([^"]*)"$/ do |cmnt|
  within("form#task_1_form",  visible: false) do
    fill_in("content", :with => cmnt,  visible: false)
  end
end
