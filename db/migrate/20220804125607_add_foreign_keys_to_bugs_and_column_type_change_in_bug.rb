class AddForeignKeysToBugsAndColumnTypeChangeInBug < ActiveRecord::Migration[7.0]
  def change
    add_column :bugs, :creator_id, :integer
    add_column :bugs, :solver_id, :integer
    add_column :bugs, :project_id, :integer
    change_column :bugs, :bug_type, :integer, :default => 1
    #Ex:- :default =>''
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
