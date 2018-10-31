class CreateOwnershipTable < ActiveRecord::Migration[4.2]
  def change
    create_table :ownerships, id: false do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :project, index: true
    end
  end
end
