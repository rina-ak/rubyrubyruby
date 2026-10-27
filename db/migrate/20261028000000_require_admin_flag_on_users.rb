class RequireAdminFlagOnUsers < ActiveRecord::Migration[8.1]
  def up
    change_column_default :users, :admin, from: nil, to: false
    execute "UPDATE users SET admin = 0 WHERE admin IS NULL"
    change_column_null :users, :admin, false
  end

  def down
    change_column_null :users, :admin, true
    change_column_default :users, :admin, from: false, to: nil
  end
end
