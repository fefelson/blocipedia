class AddOptionsToPrivateOnWikis < ActiveRecord::Migration
  def change
    change_column_default :wikis, :private, false
    change_column_null :wikis, :private, false
  end
end
