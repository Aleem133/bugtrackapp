class ChangeColumnTypeOfUserTypeInUsers < ActiveRecord::Migration[7.0]
  def change
    
    change_column :users, :usertype, :integer, :default => 1
    #Ex:- :default =>''
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
