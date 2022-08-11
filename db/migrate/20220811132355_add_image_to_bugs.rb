class AddImageToBugs < ActiveRecord::Migration[7.0]
  def change
    add_column :bugs, :image, :string
  end
end
