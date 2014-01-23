class AddTokenEmUsuarios < ActiveRecord::Migration

  def up
  	add_column :usuarios, :authentication_token, :string
  end

  def down
  	remove_column :usuarios, :authentication_token
  end
  
end
