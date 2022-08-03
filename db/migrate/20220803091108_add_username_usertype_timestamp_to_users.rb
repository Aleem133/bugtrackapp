class AddUsernameUsertypeTimestampToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string
    add_column :users, :usertype, :string
    add_column :users, :created_at, :datetime
    add_column :users, :updated_at, :datetime
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")

  end
end
